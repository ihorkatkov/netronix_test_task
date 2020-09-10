defmodule GeoTrackerWeb.TaskController do
  @moduledoc """
  Main controller for Tasks context
  """
  use GeoTrackerWeb, :controller

  alias GeoTracker.Tasks

  action_fallback GeoTrackerWeb.FallbackController

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, payload) do
    params = %{
      pickup_location: coordinates_to_geo_point(payload["pickup_location"]),
      dropoff_location: coordinates_to_geo_point(payload["dropoff_location"])
    }

    case Tasks.create_task(params) do
      {:ok, task} -> render(conn, "task.json", task: task)
      {:error, error} -> render(conn, "error.json", error: error)
    end
  end

  defp coordinates_to_geo_point(%{"lat" => lat, "long" => long}) do
    %Geo.Point{coordinates: {lat, long}}
  end
end
