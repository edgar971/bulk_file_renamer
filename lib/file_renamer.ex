defmodule FileRenamer do
  @moduledoc """
  Documentation for FileRenamer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FileRenamer.getFile
      :world

  """
  def load_file(filename) do
    case File.read(filename) do 
            {:ok, binary} -> :erlang.binary_to_term(binary)
            {:error, _reason} -> "That file does not exist" 
    end
  end
end
