defmodule GeoTracker.Factory do
  use ExMachina.Ecto, repo: GeoTracker.Repo

  alias GeoTracker.Users.User

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
