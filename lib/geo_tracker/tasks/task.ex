defmodule GeoTracker.Tasks.Task do
  @moduledoc """
  Task schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @statuses ["new", "assigned", "done"]

  schema "tasks" do
    field :dropoff_location, Geo.PostGIS.Geometry
    field :pickup_location, Geo.PostGIS.Geometry
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:pickup_location, :dropoff_location, :status])
    |> validate_required([:pickup_location, :dropoff_location, :status])
    |> validate_inclusion(:status, @statuses)
  end

  def update_changeset(task, attrs) do
    task
    |> changeset(attrs)
  end
end
