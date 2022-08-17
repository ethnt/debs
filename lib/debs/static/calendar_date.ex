defmodule Debs.Static.CalendarDate do
  @moduledoc false

  alias Debs.Static.{CalendarDate, Dataset}
  alias Debs.Utils

  @type t :: %__MODULE__{
          service_id: String.t(),
          date: String.t(),
          exception_type: String.t()
        }

  defstruct [
    :service_id,
    :date,
    :exception_type
  ]

  @spec new(map()) :: CalendarDate.t()
  def new(data) do
    struct(CalendarDate, data)
  end

  @spec load(%Dataset{source: Utils.Zip.handle()}) :: %Dataset{
          source: Utils.Zip.handle(),
          calendar_dates: [CalendarDate.t()]
        }
  def load(%Dataset{source: source} = dataset) do
    calendar_dates =
      with {:ok, file} <- Utils.Zip.get(source, "calendar_dates.txt") do
        file
        |> Utils.CSV.parse()
        |> Enum.map(fn s ->
          new(s)
        end)
      end

    %{dataset | calendar_dates: calendar_dates}
  end
end
