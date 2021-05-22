defmodule MsqhPortal.LoginController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.User

  def index(conn, _params) do
    render conn, "index.html"
  end

  def change(conn, _params) do
    changeset = User.ask_email_changeset(%User{})

    render(conn, "change.html", changeset: changeset)
  end

  def change_password(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, email: user_params["email"])
    unless is_nil(user) do
      MsqhPortal.Email.change_password_email(user.email, user) |> MsqhPortal.Mailer.deliver_later
      conn
      |> put_flash(:info, "Sent reset link to " <> user.email)
      |> redirect(to: login_path(conn, :index))
    else
      conn
      |> put_flash(:warning, "User not in database")
      |> redirect(to: login_path(conn, :index))
    end
  end

  # def reset(conn, %{"user" => user_params}) do
  #   user = Repo.get_by(User, email: user_params["email"])
  #   unless is_nil(user) do
  #     MsqhPortal.Email.change_password_email(user.email, user) |> MsqhPortal.Mailer.deliver_later
  #     conn
  #     |> put_flash(:info, "Sent reset link to " <> user.email)
  #     |> redirect(to: login_path(conn, :index))
  #   else
  #     conn
  #     |> put_flash(:warning, "User not in database")
  #     |> redirect(to: login_path(conn, :index))
  #   end
  # end
end
