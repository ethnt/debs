defmodule Debs.Static.Dataset do
  @moduledoc """
  A dataset of static scheduling information
  """

  alias Debs.Static.{
    Agency,
    Calendar,
    CalendarDate,
    Dataset,
    Route,
    Shape,
    Stop,
    StopTime,
    Transfer,
    Trip
  }

  alias Debs.Utils

  @type t :: %__MODULE__{
          source: Utils.Zip.handle(),
          agencies: [Agency.t()],
          calendar: [Calendar.t()],
          calendar_dates: [CalendarDate.t()],
          routes: [Route.t()],
          shapes: [Shape.t()],
          stops: [Stop.t()],
          stop_times: [StopTime.t()],
          trips: [Trip.t()],
          transfers: [Transfer.t()]
        }

  defstruct source: nil,
            agencies: [],
            calendar: [],
            calendar_dates: [],
            routes: [],
            stops: [],
            stop_times: [],
            trips: [],
            shapes: [],
            transfers: []

  def load(filename) do
    with {:ok, handle} <- Utils.Zip.load(filename) do
      %Dataset{source: handle}
      |> Agency.load()
      |> Calendar.load()
      |> CalendarDate.load()
      |> Stop.load()
      |> Route.load()
      |> StopTime.load()
      |> Trip.load()
      |> Transfer.load()
      |> Shape.load()
    end
  end
end
