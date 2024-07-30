defmodule HillChart.Web.Router do
  use HillChart.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ETag.Plug
    plug CORSPlug, origin: ["*"], max_age: 86400
  end

  scope "/", HillChart.Web do
    pipe_through :api

    scope "/tracked" do
      resources "/tickets", Tracked.TicketController
      resources "/projects", Tracked.ProjectController
    end
  end
end
