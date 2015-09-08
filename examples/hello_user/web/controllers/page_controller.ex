defmodule HelloUser.PageController do
  use HelloUser.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
