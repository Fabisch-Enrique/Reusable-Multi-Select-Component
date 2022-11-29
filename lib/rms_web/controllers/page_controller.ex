defmodule RmsWeb.PageController do
  use RmsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", %{
      user_path: Routes.user_path(conn, :show)
    })
  end
end
