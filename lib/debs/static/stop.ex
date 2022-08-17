defmodule Debs.Static.Stop do
  @moduledoc false

  alias Debs.Static.{Dataset, Stop}
  alias Debs.Utils

  @type t :: %__MODULE__{
          stop_id: String.t() | nil,
          stop_code: String.t() | nil,
          stop_name: String.t() | nil,
          stop_desc: String.t() | nil,
          stop_lat: String.t() | nil,
          stop_lon: String.t() | nil,
          zone_id: String.t() | nil,
          stop_url: String.t() | nil,
          location_type: String.t() | nil,
          parent_station: String.t() | nil
        }

  defstruct [
    :stop_id,
    :stop_code,
    :stop_name,
    :stop_desc,
    :stop_lat,
    :stop_lon,
    :zone_id,
    :stop_url,
    :location_type,
    :parent_station
  ]

  @spec new(map()) :: Stop.t()
  def new(data) do
    struct(Stop, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          stops: [Stop.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    stops =
      with {:ok, file} <- Utils.Zip.get(source, "stops.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(&new(&1))
      end

    %{dataset | stops: stops}
  end
end
