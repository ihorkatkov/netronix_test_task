defmodule GeoTrackerWeb.Router do
  use GeoTrackerWeb, :router

  alias GeoTrackerWeb.Plugs.VerifyApiKey

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authed_manager do
    plug :accepts, ["json"]
    plug VerifyApiKey, user_role: "manager"
  end

  pipeline :authed_driver do
    plug :accepts, ["json"]
    plug VerifyApiKey, user_role: "driver"
  end

  scope "/api/tasks", GeoTrackerWeb do
    pipe_through :authed_manager

    post "/tasks", TaskController, :create
  end

  scope "/api/tasks", GeoTrackerWeb do
    pipe_through :authed_driver

    get "/tasks", TaskController, :new_nearest
  end

  scope "/api", GeoTrackerWeb do
    pipe_through :api

    get "/tasks", TaskController, :index
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: GeoTrackerWeb.Telemetry
    end
  end
end
