defmodule Factories.UriFactory do
  @moduledoc false
  use ExUnitProperties

  def uri_generator do
    gen all scheme <- member_of(["http", "https"]),
            host <- domain_generator(),
            path <- optional_path_generator(),
            query <- optional_query_generator() do
      %URI{
        scheme: scheme,
        host: host,
        path: path,
        query: query
      }
    end
  end

  defp domain_generator do
    gen all subdomain <- string(:alphanumeric, min_length: 1, max_length: 10),
            domain <- string(:alphanumeric, min_length: 1, max_length: 10),
            tld <- member_of(["com", "org", "net", "io", "de", "dev"]) do
      "#{subdomain}.#{domain}.#{tld}"
    end
  end

  defp optional_path_generator do
    gen all path <- list_of(string(:alphanumeric, min_length: 1, max_length: 10), max_length: 5) do
      case path do
        [] -> nil
        _ -> "/" <> Enum.join(path, "/")
      end
    end
  end

  defp optional_query_generator do
    gen all params <- list_of(string(:alphanumeric, min_length: 1, max_length: 10), max_length: 5),
            values <- list_of(string(:alphanumeric, min_length: 1, max_length: 10), max_length: 5) do
      case Enum.zip(params, values) do
        [] -> nil
        pairs -> Enum.map_join(pairs, "&", fn {k, v} -> "#{k}=#{v}" end)
      end
    end
  end
end
