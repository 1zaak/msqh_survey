defmodule MsqhPortal.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  alias MsqhPortal.Router.Helpers

  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(MsqhPortal.User, username: username)
    cond do
      user && user.verified && checkpw(given_pass, user.password_hash) && !check_admin(user.state) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  @doc """
  login_by_username_and_password_hash:
  Don't need to check user is verified because this is login from verification email
  """
  def login_by_username_and_password_hash(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(MsqhPortal.User, username: username)
    cond do
      user && given_pass == user.password_hash ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def admin_login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(MsqhPortal.User, username: username)
    cond do
      user && user.verified && checkpw(given_pass, user.password_hash) && check_admin(user.state) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    # Bypassing auth logic for testing purposes only
    # cond do
    #   user = conn.assigns[:current_user] ->
    #     conn
    #   user = user_id && repo.get(MsqhPortal.User, user_id) ->
    #     assign(conn, :current_user, user)
    #   true ->
    #     assign(conn, :current_user, nil)
    #
    # end
    # Actual auth logic
    user = user_id && repo.get(MsqhPortal.User, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: Helpers.login_path(conn, :index))
      |> halt()
    end
  end

  defp check_admin(state) do
    if state === "ADMIN" || state === "SUPERADMIN" do
      true
    else
      false
    end
  end
end
