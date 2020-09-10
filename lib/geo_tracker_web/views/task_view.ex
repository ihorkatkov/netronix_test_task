defmodule GeoTrackerWeb.TaskView do
  use GeoTrackerWeb, :view
  alias GeoTrackerWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      pickup_location: render_coordinates(task.pickup_location),
      dropoff_location: render_coordinates(task.dropoff_location),
      status: task.status
    }
  end

  defp render_coordinates(%Geo.Point{coordinates: {lat, long}}) do
    %{lat: lat, long: long}
  end
end
