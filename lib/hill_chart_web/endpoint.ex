defmodule HillChartWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :hill_chart

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug HillChartWeb.Router
end
