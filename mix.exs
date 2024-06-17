defmodule HillChart.MixProject do
  use Mix.Project

  def project do
    env = Mix.env()

    [
      app: :hill_chart,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(env),
      start_permanent: env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HillChart.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps() do
    Enum.concat([
      deps_for(:api_building),
      deps_for(:web_building),
      deps_for(:persistence),
      deps_for(:dev_experience),
      deps_for(:linting),
      deps_for(:testing),
      deps_for(:logging)
    ])
  end

  defp deps_for(area)

  defp deps_for(:api_building) do
    [
      {:phoenix, "~> 1.7.12"},
      {:floki, ">= 0.30.0", only: :test},
      {:goal, "~> 0.3.1"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.2"}
    ]
  end

  defp deps_for(:web_building) do
    [
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.2"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1}
    ]
  end

  defp deps_for(:persistence) do
    [
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:uniq, "~> 0.6"}
    ]
  end

  defp deps_for(:dev_experience) do
    [
      {:ex_doc, ">= 0.0.0", runtime: false},
      {:typed_struct, "~> 0.3"}
    ]
  end

  defp deps_for(:linting) do
    [
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.16.0", only: [:test, :dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:test, :dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:test, :dev], runtime: false},
      {:doctor, ">= 0.0.0", only: [:test, :dev], runtime: false}
    ]
  end

  defp deps_for(:testing) do
    [
      {:excoveralls, "~> 0.5", only: :test},
      {:mox, "~> 1.1", only: :test}
    ]
  end

  defp deps_for(:logging) do
    [
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:logger_json, "~> 6.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate"
        # "run priv/repo/seeds.exs"
      ],
      "ecto.init": ["ecto.drop", "ecto.setup"],
      "test.next": ["test --failed --max-failures=1 --seed=0"],
      "gettext.update": ["gettext.extract", "gettext.merge priv/gettext"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind hill_chart", "esbuild hill_chart"],
      "assets.deploy": [
        "tailwind hill_chart --minify",
        "esbuild hill_chart --minify",
        "phx.digest"
      ]
    ]
  end
end
