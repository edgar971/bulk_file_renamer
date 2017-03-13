defmodule FileRenamer do
  @moduledoc """
  Documentation for FileRenamer.
  """

  @doc """
  Main function to call in order to start the process. 

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
    
    # Process only images that have a photo file
    if(String.trim(photo_id) != "") do 
      find_image_file(photo_id)
    end

  end

  def find_image_file(filename, dir \\ "data") do 
    
    Enum.each(File.ls!(dir), fn file ->
      IO.puts fname = "#{dir}/#{file}  - #{filename}"

      # if File.dir?(fname), do: find_image_file(fname)
    end)

  end


end
