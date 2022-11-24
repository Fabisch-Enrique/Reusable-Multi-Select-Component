defmodule RmsWeb.PageController do
  use RmsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
