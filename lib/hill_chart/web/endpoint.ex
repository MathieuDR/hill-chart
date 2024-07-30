defmodule HillChart.Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :hill_chart

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug CORSPlug

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug HillChart.Web.Router
end
