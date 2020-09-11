defmodule GeoTracker.Factory do
  @moduledoc """
  Fixtures factory
  """
  use ExMachina.Ecto, repo: GeoTracker.Repo

  alias GeoTracker.Tasks.Task
  alias GeoTracker.Users.User

  def task_factory do
    %Task{
      pickup_location: %Geo.Point{coordinates: {1.0, 1.0}},
      dropoff_location: %Geo.Point{coordinates: {1.1, 1.1}},
      status: "new"
    }
  end

  def driver_factory do
    %User{
      api_key: UUID.uuid4(),
      role: "driver"
    }
  end

  def manager_factory do
    Map.put(driver_factory(), :role, "manager")
  end
end
