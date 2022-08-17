defmodule Debs.Static.Trip do
  @moduledoc false

  alias Debs.Static.{Dataset, Trip}
  alias Debs.Utils

  @type t :: %__MODULE__{
          route_id: String.t(),
          service_id: String.t(),
          trip_id: String.t(),
          trip_headsign: String.t() | nil,
          trip_short_name: String.t() | nil,
          direction_id: String.t() | nil,
          block_id: String.t() | nil,
          shape_id: String.t() | nil,
          wheelchair_accessible: String.t() | nil,
          bikes_allowed: String.t() | nil
        }

  defstruct [
    :route_id,
    :service_id,
    :trip_id,
    :trip_headsign,
    :trip_short_name,
    :direction_id,
    :block_id,
    :shape_id,
    :wheelchair_accessible,
    :bikes_allowed
  ]

  @spec new(map()) :: Trip.t()
  def new(data) do
    struct(Trip, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          trips: [Trip.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    trips =
      with {:ok, file} <- Utils.Zip.get(source, "trips.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(&new(&1))
      end

    %{dataset | trips: trips}
  end
end
