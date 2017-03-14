# FileRenamer


## Usage

1. Place images folder to the `./data/original` directory.
1. Place CSV file inside `./data/`
1. Run the Elixir Docker Container: `docker run -it -v $(pwd)/:/app -w '/app' elixir bash`
1. Install any required Hex packages: `mix deps.get` 
1. Run the Elixir Interface: `iex -S mix`
1. Call the `FileRenamer.main` function: `FileRenamer.main("data/festival.csv")`

## Using Docker



