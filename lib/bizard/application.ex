# TODO use path utility 
# TODO check for XSS
# TODO use CSRFProtection
defmodule Bizard.Webserver do
  use Plug.Router
  require EEx
  import Plug.Conn

  EEx.function_from_file(:defp, :index, "lib/bizard/template/index.heex", [:content])
  EEx.function_from_file(:defp, :new, "lib/bizard/template/new.heex")

  plug(Plug.Logger)
  plug(:conditional_cookies)
  plug(:match)
  plug(:dispatch)

  def conditional_cookies(%Plug.Conn{path_info: ["new" | _]} = conn, _opts) do
    conn
  end

  def conditional_cookies(conn, _opts) do    
    # TODO use redirectional path as option
    Bizard.Plug.CookieAuth.call(conn, [])
  end

  get "/new" do
    content = index(new())
    conn
    |> send_resp(200, content)
    |> halt()
  end

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, index("Hello Elixir"))
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
    {:ok, pid} = Supervisor.start_link(children, opts)
    Logger.info("Server running on http://localhost:#{port}")
    {:ok, pid}
  end
end
