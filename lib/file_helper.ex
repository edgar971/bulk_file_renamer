defmodule FileRenamer.File do
  @moduledoc """
  Documentation for FileRenamer.File
  
  ## Usage
  1. Place images folder to the `./data/original` directory.
  1. Place CSV file inside `./data/`
  1. Install any required Hex packages: `mix deps.get` 
  1. Run the Elixir Interface: `iex -S mix`
  1. Call the `FileRenamer.main` function: `FileRenamer.main("data/example.csv")`
  1. Any matched images will be saved under `./data/processed` using the same directory structure.
  """

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
          
          IO.puts("++ Found Image #{full_filepath}")
          extension = Path.extname(file)
          copy_image(%FileRenamer.Image{name: file, file_path: dir, extension: extension }, upc)
          
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

      row_filename == filename

    end
    
    
  end


  @doc """
  This function copies the file to the new destination. It also renames it. 
  """
  def copy_image(%FileRenamer.Image{name: name, file_path: file_path, extension: extension }, upc) do 
      
      # Ignore the first two directories
      [_first, _second | tail] = Path.split(file_path)
      
      # Create the directory structure for the new file
      destination_dir = Enum.concat(["data","processed"], tail) |> Path.join

      # Create it if it doesn't exist
      if !File.exists?(destination_dir), do: File.mkdir_p(destination_dir)

      # Copy it
      File.copy("#{file_path}/#{name}", "#{destination_dir}/#{upc}#{extension}")

  end



end
