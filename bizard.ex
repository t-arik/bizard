defmodule Bizard do
  @moduledoc """
  This is the main module which registers supervision tree and initial config
  """
  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    port =
      case System.fetch_env("PORT") do
        {:ok, port} -> String.to_integer(port)
        _ -> 2000
      end

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
