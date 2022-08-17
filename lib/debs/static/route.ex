defmodule Debs.Static.Route do
  @moduledoc false

  alias Debs.Static.{Dataset, Route}
  alias Debs.Utils

  @type t :: %__MODULE__{
          route_id: String.t(),
          agency_id: String.t(),
          route_short_name: String.t(),
          route_long_name: String.t(),
          route_desc: String.t(),
          route_type: String.t(),
          route_url: String.t(),
          route_color: String.t(),
          route_text_color: String.t(),
          route_sort_order: String.t(),
          continuous_pickup: String.t(),
          continuous_drop_off: String.t(),
          network_id: String.t()
        }

  defstruct [
    :route_id,
    :agency_id,
    :route_short_name,
    :route_long_name,
    :route_desc,
    :route_type,
    :route_url,
    :route_color,
    :route_text_color,
    :route_sort_order,
    :continuous_pickup,
    :continuous_drop_off,
    :network_id
  ]

  @spec new(map()) :: Route.t()
  def new(data) do
    struct(Route, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          routes: [Route.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    routes =
      with {:ok, file} <- Utils.Zip.get(source, "routes.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(fn s ->
          new(s)
        end)
      end

    %{dataset | routes: routes}
  end
end
