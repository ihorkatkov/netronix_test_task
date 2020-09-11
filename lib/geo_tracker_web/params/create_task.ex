defmodule GeoTrackerWeb.Params.CreateTask do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  use Params.Schema

  alias GeoTrackerWeb.Params.Location

  @required ~w(pickup_location dropoff_location)a

  embedded_schema do
    embeds_one(:pickup_location, Location)
    embeds_one(:dropoff_location, Location)
  end

  def to_valid_attrs(%{} = params) do
    case from(params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        params =
          changeset
          |> Params.to_map()
          |> Map.update!(:pickup_location, &coordinates_to_geo_point/1)
          |> Map.update!(:dropoff_location, &coordinates_to_geo_point/1)

        {:ok, params}

      changeset ->
        {:error, changeset}
    end
  end

  def coordinates_to_geo_point(%{lat: lat, long: long}) do
    %Geo.Point{coordinates: {lat, long}}
  end
end
