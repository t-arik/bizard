# TODO use path utility 
# TODO check for XSS
# TODO use CSRFProtection
defmodule Bizard.Webserver do
  use Agent
  use Plug.Router

  def init(opts) do
    {:ok, _} = Agent.start_link(fn -> Bizard.Game.new() end, name: __MODULE__)
    super(opts)
  end

  plug(Plug.Logger)
  plug(:provide_game_state)
  plug(:match)
  plug(:dispatch)
  plug(:update_game_state)

  defp provide_game_state(conn, _opts) do
    game = Agent.get(__MODULE__, &(&1))
    Bizard.Plug.Conn.set_game(conn, game)
  end

  defp update_game_state(conn, _opts) do
    game = conn.assigns[:game]
    Agent.update(__MODULE__, fn _ -> game end)
    IO.inspect(game)
    conn
  end

  forward("/register", to: Bizard.Plug.Register)
  forward("/", to: Bizard.Plug.Game)
end

defmodule Bizard.Application do
  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    port = 4000

    webserver = {
      Plug.Cowboy,
      plug: Bizard.Webserver, scheme: :http, options: [port: port]
    }

    children = [webserver]

    Logger.info("Server running on http://localhost:#{port}")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
