defmodule MsqhPortal.AdminLoginController do
  use MsqhPortal.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
