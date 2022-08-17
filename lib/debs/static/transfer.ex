defmodule Debs.Static.Transfer do
  @moduledoc false

  alias Debs.Static.{Dataset, Transfer}
  alias Debs.Utils

  @type t :: %__MODULE__{
          from_stop_id: String.t() | nil,
          to_stop_id: String.t() | nil,
          from_route_id: String.t() | nil,
          to_route_id: String.t() | nil,
          from_trip_id: String.t() | nil,
          to_trip_id: String.t() | nil,
          transfer_type: String.t(),
          min_transfer_type: String.t() | nil
        }

  defstruct [
    :from_stop_id,
    :to_stop_id,
    :from_route_id,
    :to_route_id,
    :from_trip_id,
    :to_trip_id,
    :transfer_type,
    :min_transfer_type
  ]

  @spec new(map()) :: Transfer.t()
  def new(data) do
    struct(Transfer, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          transfers: [Transfer.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    transfers =
      with {:ok, file} <- Utils.Zip.get(source, "transfers.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(fn s ->
          new(s)
        end)
      end

    %{dataset | transfers: transfers}
  end
end
