defmodule HillChart.Repo do
  use Ecto.Repo,
    otp_app: :hill_chart,
    adapter: Ecto.Adapters.Postgres
end
