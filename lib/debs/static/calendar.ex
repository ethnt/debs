defmodule Debs.Static.Calendar do
  @moduledoc false

  alias Debs.Static.{Calendar, Dataset}
  alias Debs.Utils

  @type t :: %__MODULE__{
          service_id: String.t(),
          monday: String.t(),
          tuesday: String.t(),
          wednesday: String.t(),
          thursday: String.t(),
          friday: String.t(),
          saturday: String.t(),
          sunday: String.t(),
          start_date: String.t(),
          end_date: String.t()
        }

  defstruct [
    :service_id,
    :monday,
    :tuesday,
    :wednesday,
    :thursday,
    :friday,
    :saturday,
    :sunday,
    :start_date,
    :end_date
  ]

  @spec new(map()) :: Calendar.t()
  def new(data) do
    struct(Calendar, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          calendar: [Calendar.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    calendar =
      with {:ok, file} <- Utils.Zip.get(source, "calendar.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(fn s ->
          new(s)
        end)
      end

    %{dataset | calendar: calendar}
  end
end
