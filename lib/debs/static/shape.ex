defmodule Debs.Static.Shape do
  @moduledoc false

  alias Debs.Static.{Dataset, Shape}
  alias Debs.Utils

  @type t :: %__MODULE__{
          shape_id: String.t(),
          shape_pt_lat: String.t(),
          shape_pt_lon: String.t(),
          shape_pt_sequence: String.t(),
          shape_dist_traveled: String.t() | nil
        }

  defstruct [
    :shape_id,
    :shape_pt_lat,
    :shape_pt_lon,
    :shape_pt_sequence,
    :shape_dist_traveled
  ]

  @spec new(map()) :: Shape.t()
  def new(data) do
    struct(Shape, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          shapes: [Shape.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    shapes =
      with {:ok, file} <- Utils.Zip.get(source, "shapes.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(fn s ->
          new(s)
        end)
      end

    %{dataset | shapes: shapes}
  end
end
