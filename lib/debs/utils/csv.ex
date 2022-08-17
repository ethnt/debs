defmodule Debs.Utils.CSV do
  @moduledoc false

  @doc """
  Parse a CSV from a stream and atomize the keys in the map representing each row
  """
  @spec parse(IO.Stream.t(), headers: boolean) :: [%{required(atom) => any}]
  def parse(stream, opts \\ [headers: true]) do
    stream
    |> CSV.decode(opts)
    |> Enum.map(fn {:ok, value} -> value end)
    |> Enum.map(fn x -> for {k, v} <- x, into: %{}, do: {String.to_atom(k), v} end)
  end
end
