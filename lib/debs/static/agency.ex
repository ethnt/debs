defmodule Debs.Static.Agency do
  @moduledoc false

  alias Debs.Static.{Agency, Dataset}
  alias Debs.Utils

  @type t :: %__MODULE__{
          agency_id: String.t(),
          agency_name: String.t(),
          agency_url: String.t(),
          agency_timezone: String.t(),
          agency_lang: String.t() | nil,
          agency_phone: String.t() | nil,
          agency_fare_url: String.t() | nil,
          agency_email: String.t() | nil
        }

  defstruct [
    :agency_id,
    :agency_name,
    :agency_url,
    :agency_timezone,
    :agency_lang,
    :agency_phone,
    :agency_fare_url,
    :agency_email
  ]

  @spec new(map()) :: Agency.t()
  def new(data) do
    struct(Agency, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          agencies: [Agency.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    agencies =
      with {:ok, file} <- Utils.Zip.get(source, "agency.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(&new(&1))
      end

    %{dataset | agencies: agencies}
  end
end
