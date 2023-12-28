defmodule Bizard.Plug.CookieAuth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  # TODO make redirect an option instead of hardcoded
  def call(conn, redirect: url, required_cookie: cookie) do
    conn = fetch_cookies(conn)

    if Map.get(conn.cookies, cookie) do
      conn
    else
      conn
      |> put_resp_header("location", url)
      |> send_resp(302, "")
      |> halt()
    end
  end
end
