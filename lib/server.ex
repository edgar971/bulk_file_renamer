defmodule FileRenamer.Server do
    
    use GenServer

    def start_link() do 
        GenServer.start_link(__MODULE__, :ok, name: :renamer_server)
    end

    def init(:ok) do 
        
        {:ok, %{}}

    end

    def handle_call({:process, rows}, _from, all_rows) do
        
        FileRenamer.CSV.process_rows(rows)
        
        {:reply, rows, all_rows}

    end

    def process(rows) do 

        GenServer.call(:renamer_server, {:process, rows})

    end



end