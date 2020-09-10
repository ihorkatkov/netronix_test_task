defmodule GeoTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :pickup_location, :geometry
      add :dropoff_location, :geometry
      add :status, :string

      timestamps()
    end
  end
end
