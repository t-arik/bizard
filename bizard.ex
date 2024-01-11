defmodule Bizard do
  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    port = 5000

    webserver = {
      Plug.Cowboy,
      plug: Bizard.Controller.Main,
      scheme: :http,
      options: [port: port],
      protocol_options: [idle_timeout: :infinity]
    }

    children = [
      Bizard.Component.Game,
      Bizard.Component.EventPubSub,
      webserver
    ]

    Logger.info("Server running on http://localhost:#{port}")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
