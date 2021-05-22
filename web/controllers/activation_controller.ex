defmodule MsqhPortal.ActivationController do
  use MsqhPortal.Web, :controller
  alias MsqhPortal.User

  def confirm(conn, %{"confirm_id" => confirm_id}) do
    user = Repo.get_by(User, confirm_id: confirm_id)
    changeset = User.confirm_changeset(user, %{"verified" => true})
    case Repo.update(changeset) do
      {:ok, user} ->
        case MsqhPortal.Auth.login_by_username_and_password_hash(conn, user.username, user.password_hash, repo: Repo) do
          {:ok, conn} ->
            if user.state == "INACTIVE" || user.state == "ACTIVE" || user.state == "PAID" || user.state == "EXPIRED" do
              conn
              |> put_flash(:info, "Welcome, " <> user.username)
              |> redirect(to: user_path(conn, :index))
            else
              conn
              |> put_flash(:info, "Welcome, " <> user.username)
              |> redirect(to: admin_path(conn, :index))
            end
          {:error, _reason, conn} ->
            conn
            |> put_flash(:error, "Invalid username/password combination")
            |> redirect(to: login_path(conn, :index))
        end
      {:error, _changeset} ->
        conn
        |> redirect(to: "/")
    end

  end
end
