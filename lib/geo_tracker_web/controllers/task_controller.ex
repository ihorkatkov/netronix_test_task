defmodule GeoTrackerWeb.TaskController do
  @moduledoc """
  Main controller for Tasks context
  """
  use GeoTrackerWeb, :controller

  alias GeoTracker.Tasks
  alias GeoTrackerWeb.Params

  action_fallback GeoTrackerWeb.FallbackController

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, payload) do
    with {:ok, params} <- Params.CreateTask.to_valid_attrs(payload),
         {:ok, task} <- Tasks.create_task(params) do
      render(conn, "task.json", task: task)
    end
  end
end
