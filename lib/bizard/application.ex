defmodule Bizard.Webserver do
  require EEx
  import Plug.Conn
  # TODO use path utility 
  EEx.function_from_file(:defp, :index, "web/index.heex")

  def init(options) do
    options
  end

  def call(conn, _opts) do

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index())
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
    {:ok, pid} = Supervisor.start_link(children, opts)
    Logger.info("Server running on http://localhost:#{port}")
    {:ok, pid}
  end
end
