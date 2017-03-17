defmodule FileRenamer.CSV do
    @moduledoc """
    Documentation for FileRenamer.CSV

    """

    def process(filename) do 

        decode(filename)
        |> get_rows
        |> process_rows

    end
    @doc """

    Decodes a CSV file and returns the stream

    """
    def decode(filename) do
        
        File.stream!(filename)
        |> CSV.Decoder.decode
        |> Enum.to_list

    end

    @doc """
    Gets the rows from the csv file, this removed any of the header rows. 

    """
    def get_rows(csv) do 

        [ _ | tail] = csv

        tail

    end

    @doc """
    Gets the headers from the csv file, this assumes that the first row are the headers. 

    """
    def get_headers(csv) do 

        List.first(csv)
        
    end

    @doc """
    Process the `csv` file given.

    """
    def process_rows(rows) do
        
        Enum.each(rows, &process_row/1)

    end

    @doc """
    Process each of of the csv file. 
    We only care about the first 3 columns, the rest if not needed. 

    """
    def process_row([upc, description, photo_id | _tail] = _row) do
        
        
        # Process only images that have a photo file
        trimmed_photo_id = String.trim(photo_id) |> String.downcase

        if(trimmed_photo_id != "") do 
            
            header = ["UPC", "Description", "Photo ID"]
            TableRex.quick_render!([[upc, description, photo_id]], header) |> IO.puts

            # Search for the image
            FileRenamer.File.find_image_file(trimmed_photo_id, upc)

        end

        

    end


end