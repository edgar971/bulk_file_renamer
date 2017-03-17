defmodule FileRenamer do

    use Application

    # See http://elixir-lang.org/docs/stable/elixir/Application.html
    # for more information on OTP Applications
    def start(_type, _args) do
        import Supervisor.Spec, warn: false

        # Define workers and child supervisors to be supervised
        children = [
            # Starts a worker by calling: TweetApp.Worker.start_link(arg1, arg2, arg3)
            worker(FileRenamer.Server, []),
        ]

        # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
        # for other strategies and supported options
        opts = [strategy: :one_for_one, name: FileRenamer.Supervisor]
        process = Supervisor.start_link(children, opts)

       

        # Make sure we return the process. Elixir needs to know and track it. 
        process

    end

end