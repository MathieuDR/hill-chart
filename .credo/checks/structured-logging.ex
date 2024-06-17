defmodule Extensions.Credo.StructuredLogging do
  @moduledoc false
  use Credo.Check,
    category: :refactor,
    base_priority: :higher,
    explanations: [
      check:
        "Collects Logger calls that interpolate values into their message instead of using metadata.",
      params: []
    ]

  @doc false
  @impl true
  def run(%SourceFile{} = source_file, params) do
    # IssueMeta helps us pass down both the source_file and params of a check
    # run to the lower levels where issues are created, formatted and returned
    issue_meta = IssueMeta.for(source_file, params)

    Credo.Code.prewalk(source_file, fn ast, issues ->
      case check_ast(ast) do
        :ok ->
          {ast, issues}

        {:error, issue_opts} ->
          {ast, [format_issue(issue_meta, issue_opts) | issues]}
      end
    end)
  end

  defp check_ast({{:., meta, [module, function]}, _, arguments} = ast) do
    if logger?(module) and unstructured_log?(function, arguments) do
      {:error,
       message:
         ~s'[Structured Logging] Use metadata instead of interpolating: #{abbreviate_call(ast)}',
       trigger: Macro.to_string(ast),
       line_no: meta[:line],
       column: meta[:column]}
    else
      :ok
    end
  end

  defp check_ast(_), do: :ok

  defp logger?({:__aliases__, _, [:Logger]}), do: true
  defp logger?({:__aliases__, [alias: Logger], [_]}), do: true
  defp logger?(_), do: false

  @levels [:emergency, :alert, :critical, :error, :warning, :warn, :notice, :info, :debug]
  # Logger.log(<level>, <message>, <metadata>)
  defp unstructured_log?(:log, [_level, message | _]), do: dynamic?(message)
  defp unstructured_log?(level, [message | _]) when level in @levels, do: dynamic?(message)
  defp unstructured_log?(_other, _args), do: false

  # Strings
  defp dynamic?({:<>, _, parts}), do: Enum.any?(parts, &dynamic?/1)
  defp dynamic?({:<<>>, _, parts}), do: Enum.any?(parts, &dynamic?/1)
  # Binary parts
  defp dynamic?({:"::", _meta, [value, _type]}), do: dynamic?(value)

  # Calls
  defp dynamic?({{:., _, [Kernel, :to_string]}, _, [value]}), do: dynamic?(value)
  # Atom.to_string/1 | Date.to_string/1 etc. etc. - safe to assume it's side-effect free
  defp dynamic?({{:., _, [_, :to_string]}, _, [value]}), do: dynamic?(value)
  defp dynamic?({{:., _, [Kernel, :inspect]}, _, [value | _opts]}), do: dynamic?(value)
  defp dynamic?({:to_string, _, [value]}), do: dynamic?(value)
  defp dynamic?({:inspect, _, [value | _]}), do: dynamic?(value)

  # We consider all calls except for `to_string` and `inspect` as dynamic because we don't know if the functions are pure
  defp dynamic?({{:., _, [_module, _function]}, _, _arguments}), do: true

  # Module attributes
  defp dynamic?({:@, _, [_name]}), do: false

  # Variables
  defp dynamic?({var, _, context}) when is_atom(var) and is_atom(context), do: true

  # Everything else
  defp dynamic?(_), do: false

  defp abbreviate_call(ast) do
    {module, function, arguments} = Macro.decompose_call(ast)

    arguments =
      if function == :log do
        [level, message | metadata] = arguments

        [level, abbreviate_msg(message) | abbreviate_metadata(metadata)]
      else
        [message | metadata] = arguments

        [abbreviate_msg(message) | abbreviate_metadata(metadata)]
      end

    Macro.to_string({{:., [], [module, function]}, [], arguments})
  end

  defp abbreviate_msg({:<>, _, [_first, {:<>, _, _} = nested]}) do
    abbreviate_msg(nested)
  end

  defp abbreviate_msg({:<>, _, [_first, second]}) do
    {:<>, [], ["...", second]}
  end

  defp abbreviate_msg({:<<>>, _, [_first, second | _rest]}) do
    {:<<>>, [], ["... ", second, " ..."]}
  end

  defp abbreviate_msg(other), do: other

  defp abbreviate_metadata([]), do: []
  defp abbreviate_metadata(_more), do: [Macro.var(:_meta, nil)]
end
