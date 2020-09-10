defmodule GeoTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :api_key, :string
      add :role, :string

      timestamps()
    end
  end
end
