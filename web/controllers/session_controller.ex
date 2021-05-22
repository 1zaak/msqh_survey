defmodule MsqhPortal.SessionController do
  use MsqhPortal.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case MsqhPortal.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back, " <> user)
        |> redirect(to: user_path(conn, :index))
      {:error, _reason, conn} ->        
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> redirect(to: login_path(conn, :index))
    end
  end

  def delete(conn, _) do
    conn
    |> MsqhPortal.Auth.logout()
    |> redirect(to: login_path(conn, :index))
  end
end
