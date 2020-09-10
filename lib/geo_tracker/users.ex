defmodule GeoTracker.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias GeoTracker.Repo

  alias GeoTracker.Users.User

  @doc """
  Gets a single user by api key and role.
  """
  def get_user(api_key, role), do: Repo.get_by(User, api_key: api_key, role: role)
end
