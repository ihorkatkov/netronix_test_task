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
    field :status, :string, default: "new"

    timestamps()
  end

  def status_transition_rules do
    %{"new" => ["assigned"], "assigned" => ["done"], "done" => []}
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
    |> validate_status_change()
  end

  def validate_status_change(changeset) do
    validate_change(changeset, :status, fn :status, status ->
      next_valid_statuses = Map.get(status_transition_rules(), changeset.data.status)

      if status in next_valid_statuses do
        []
      else
        [status: "not permitted status change. Valid values are #{inspect(next_valid_statuses)}"]
      end
    end)
  end
end
