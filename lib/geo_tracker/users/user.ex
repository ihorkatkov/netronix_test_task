defmodule GeoTracker.Users.User do
  @moduledoc """
  User schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :api_key, :string
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:api_key, :role])
    |> validate_required([:api_key, :role])
  end
end
