defmodule MsqhPortal.AdminMembershipSettingController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.MembershipSetting

  def index(conn, params) do
    unless is_nil(conn.assigns.current_user) do
      if conn.assigns.current_user.state === "ADMIN" || conn.assigns.current_user.state === "SUPERADMIN" do

        membership_settings = Repo.all MembershipSetting
        render conn, :index, membership_settings: membership_settings
      else
        conn
        |> put_flash(:error, "Only admin can access this page.")
        |> redirect(to: login_path(conn, :index))
      end
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = MembershipSetting.changeset(%MembershipSetting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"membership_setting" => membership_setting_params}) do
    changeset = MembershipSetting.changeset(%MembershipSetting{}, membership_setting_params)

    case Repo.insert(changeset) do
      {:ok, _membership_setting} ->
        conn
        |> put_flash(:info, "Notification setting created successfully.")
        |> redirect(to: admin_membership_setting_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
