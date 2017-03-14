defmodule FileRenamer do
  @moduledoc """
  Documentation for FileRenamer.
  
  ## Usage
  1. Place images folder to the `./data/original` directory.
  1. Place CSV file inside `./data/`
  1. Install any required Hex packages: `mix deps.get` 
  1. Run the Elixir Interface: `iex -S mix`
  1. Call the `FileRenamer.main` function: `FileRenamer.main("data/example.csv")`
  1. Any matched images will be saved under `./data/processed` using the same directory structure.
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
  Process the `csv` file given.

  """
  def process_csv(csv) do

    { headers, rows } = Enum.split(csv, 2)
    
    Enum.each(rows, &process_row/1)

  end

  
  @doc """
  Process each of of the csv file. 
  We only care about the first 3 columns, the rest if not needed. 

  """
  def process_row([upc, description, photo_id | _tail] = row) do
    
    # Process only images that have a photo file
    trimmed_photo_id = String.trim(photo_id) |> String.downcase

    if(trimmed_photo_id != "") do 
      # Search for the image
      find_image_file(trimmed_photo_id, upc)
    end

  end

  @doc """
  This function copies the file to the new destination. It also renames it. 
  """
  def copy_image(%FileRenamer.File{name: name, file_path: file_path, extension: extension }, upc) do 
      
      [_first, _second | tail] = Path.split(file_path)
      
      # Create the directory structure for the new file
      destination_dir = Enum.concat(["data","processed"], tail) |> Path.join

      # Create it if it doesn't exist
      if !File.exists?(destination_dir), do: File.mkdir_p(destination_dir)

      # Copy it
      File.copy("#{file_path}/#{name}", "#{destination_dir}/#{upc}#{extension}")

  end

  @doc """
  Recursively searches through files and directories and copies the file if found.
  """
  def find_image_file(row_filename, upc, dir \\ "data") do 
      
      # Map each file and call the copy function if it's found
      Enum.map(File.ls!(dir), fn(file) -> 
      
        clean_filename = String.trim(file) |> String.downcase |> Path.rootname
        full_filepath = "#{dir}/#{file}"

        if File.dir?(full_filepath), do: find_image_file(row_filename, upc, full_filepath)

        if(does_filename_match?(row_filename, clean_filename)) do 

          extension = Path.extname(file)
          copy_image(%FileRenamer.File{name: file, file_path: dir, extension: extension }, upc)
          
        end

      end)
      

  end

  @doc """
  Determines if the filename is a match based on different naming patterns used. 
  """
  def does_filename_match?(row_filename, filename) do 
    
    # Neal 100-5813 -> DSC05813.JPG
    # Loy 102-0062 -> IMG_0062.JPG
    # Match the last 4 for Loy and Neal
    if(!String.starts_with?(row_filename, ["zlc", "_zlc"])) do 
      
      String.ends_with?(filename, String.slice(row_filename, -4..-1)) 

    else

      false

    end
    

    # Bill ZLC_2807 -> 

    # Zak _ZLC6638 -> 
    
  end



end
