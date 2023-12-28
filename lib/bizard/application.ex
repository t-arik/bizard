# TODO use path utility 
# TODO check for XSS
# TODO use CSRFProtection
defmodule Bizard.Webserver do
  use Plug.Router
  import Plug.Conn

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  match("/") do
    Bizard.Plug.Game.call(conn, nil)
  end

  match("/register") do
    Bizard.Plug.Register.call(conn, nil)
  end

  match _ do
    conn
    |> send_resp(404, "Not Found")
  end
end

defmodule Bizard.Application do
  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    port = 4000
    webserver = {Plug.Cowboy, plug: Bizard.Webserver, scheme: :http, options: [port: port]}
    children = [webserver]

    opts = [strategy: :one_for_one, name: Bizard.Supervisor]
    Logger.info("Server running on http://localhost:#{port}")
    Supervisor.start_link(children, opts)
  end
end
