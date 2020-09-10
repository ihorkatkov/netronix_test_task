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
end
