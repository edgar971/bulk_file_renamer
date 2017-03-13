defmodule FileRenamer do
  @moduledoc """
  Documentation for FileRenamer.
  """

  def main(filename) do 

    File.stream!(filename)
    |> CSV.Decoder.decode
    |> process_csv

  end

  @doc """
  Hello world.

  ## Examples

      iex> FileRenamer.getFile
      :world

  """
  def process_csv(csv) do

    { headers, rows } = Enum.split(csv, 2)
    
    Enum.each(rows, &process_row/1)

  end

  def process_row([upc, description, photo_id | _tail] = row) do

    if(photo_id)

  end


end
