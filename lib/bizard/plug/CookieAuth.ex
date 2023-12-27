defmodule Bizard.Plug.CookieAuth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  # TODO make redirect an option instead of hardcoded
  def call(conn, _opts) do
    conn = fetch_cookies(conn)
    IO.inspect(conn.cookies)

    if Map.get(conn.cookies, "user") do
      conn
    else
      conn
      |> put_resp_header("location", "/new")
      |> send_resp(302, "")
      |> halt()
    end
  end
end
