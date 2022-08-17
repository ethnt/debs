defmodule Debs.Utils.Zip do
  @moduledoc """
  Utilities for dealing with zip archives
  """

  @type handle :: :zip.handle()

  @doc """
  Load a zip archive (into memory by default)
  """
  @spec load(String.t(), [:memory | :cooked]) :: {:ok, handle()} | {:error, any}
  def load(filename, opts \\ [:memory]) do
    filename
    |> String.to_charlist()
    |> :zip.zip_open(opts)
  end

  @doc """
  Get a file from a zip archive and return a IO stream
  """
  @spec get(handle(), String.t()) :: {:ok, IO.Stream.t()} | {:error, any()}
  def get(handle, filename) do
    filename = filename |> String.to_charlist()

    with {:ok, {_, contents}} <- :zip.zip_get(filename, handle),
         {:ok, file} <- StringIO.open(contents) do
      {:ok, IO.stream(file, :line)}
    else
      err -> err
    end
  end
end
