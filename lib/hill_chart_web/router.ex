defmodule HillChartWeb.Router do
  use HillChartWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ETag.Plug
  end

  scope "/", HillChartWeb do
    pipe_through :api

    scope "/tracked" do
      resources "/tickets", Tracked.TicketController
    end
  end
end
