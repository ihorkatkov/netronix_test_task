defmodule GeoTrackerWeb.Params.Location do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  use Params.Schema

  @required ~w(lat long)a

  embedded_schema do
    field(:lat, :float)
    field(:long, :float)
  end

  def to_valid_attrs(%{} = params) do
    params
    |> from()
    |> to_map()
  end

  @spec to_map(Ecto.Changeset.t()) :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  defp to_map(%Ecto.Changeset{valid?: true} = params), do: {:ok, Params.to_map(params)}
  defp to_map(%Ecto.Changeset{} = changeset), do: {:error, changeset}
end
