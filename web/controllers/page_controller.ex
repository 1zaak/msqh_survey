defmodule Msqh.PageController do
  use Msqh.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
