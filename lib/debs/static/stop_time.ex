defmodule Debs.Static.StopTime do
  @moduledoc false

  alias Debs.Static.{Dataset, StopTime}
  alias Debs.Utils

  @type t :: %__MODULE__{
          trip_id: String.t(),
          arrival_time: String.t() | nil,
          departure_time: String.t() | nil,
          stop_id: String.t(),
          stop_sequence: String.t(),
          stop_headsign: String.t() | nil,
          pickup_type: String.t() | nil,
          drop_off_type: String.t() | nil,
          continuous_pickup: String.t() | nil,
          continuous_dropoff: String.t() | nil,
          shape_dist_traveled: String.t() | nil,
          timepoint: String.t() | nil
        }

  defstruct [
    :trip_id,
    :arrival_time,
    :departure_time,
    :stop_id,
    :stop_sequence,
    :stop_headsign,
    :pickup_type,
    :drop_off_type,
    :continuous_pickup,
    :continuous_dropoff,
    :shape_dist_traveled,
    :timepoint
  ]

  def new(data) do
    struct(StopTime, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          stop_times: [StopTime.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    stop_times =
      with {:ok, file} <- Utils.Zip.get(source, "stop_times.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(fn s ->
          new(s)
        end)
      end

    %{dataset | stop_times: stop_times}
  end
end
