defmodule HillChart.Release do
  @moduledoc """
  Helpers for running migrations and rollbacks on the released application

  Based on this [blog post from dashbit](https://dashbit.co/blog/automatic-and-manual-ecto-migrations)
  """

  @app :hill_chart

  @doc """
  Run all pending migrations
  """
  def migrate do
    load_app()

    for repo <- repos() do
      path = Ecto.Migrator.migrations_path(repo)
      run_migrations(repo, path)
    end
  end

  defp run_migrations(repo, path) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, path, :up, all: true))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
