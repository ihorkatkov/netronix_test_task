defmodule GeoTrackerWeb.TaskController do
  @moduledoc """
  Main controller for Tasks context
  """
  use GeoTrackerWeb, :controller

  alias GeoTracker.Tasks
  alias GeoTracker.Tasks.Task
  alias GeoTrackerWeb.Params

  action_fallback GeoTrackerWeb.FallbackController

  def new_nearest(conn, payload) do
    case Params.Location.to_valid_attrs(payload) do
      {:ok, location} ->
        tasks =
          location
          |> Params.CreateTask.coordinates_to_geo_point()
          |> Tasks.list_nearest_tasks("new")

        render(conn, "index.json", tasks: tasks)

      {:error, _error} = error ->
        error
    end
  end

  def create(conn, payload) do
    with {:ok, params} <- Params.CreateTask.to_valid_attrs(payload),
         {:ok, task} <- Tasks.create_task(params) do
      render(conn, "task.json", task: task)
    end
  end

  def update(conn, payload) do
    with {:ok, params} <- Params.UpdateTask.to_valid_attrs(payload),
         %Task{} = task <- Tasks.get_task(params.id),
         {:ok, task} <- Tasks.update_task(task, Map.take(params, [:status])) do
      render(conn, "task.json", task: task)
    else
      nil -> {:error, :not_found}
      error -> error
    end
  end
end
