defmodule RestApi.Application do
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    port = 6996

    children = [
      # Starts a worker by calling: RestApi.Worker.start_link(arg)
      # {RestApi.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: RestApi.Server, options: [port: port]}
    ]

    Logger.info("Running the server on: http://localhost:#{port}")
    opts = [strategy: :one_for_one, name: RestApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
