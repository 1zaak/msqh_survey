defmodule MsqhPortal.ProfileController do
  use MsqhPortal.Web, :controller
  alias MsqhPortal.Cv
  alias MsqhPortal.MemberCert
  alias MsqhPortal.User
  alias MsqhPortal.Facility

  plug :load_facilities when action in [:index, :edit, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end
  @doc """
  Display and edit:
  - Membership Category (MEMBERSHIP table),
  - Title, Name, NRIC, Date of Birth, Gender, Race, Nationality, Mailing address
  Professional Designation, Qualification (USER table)
  - CV (upload and download PDF)
  - Parent account (facility_id, facility_name in USER & FACILITY tables)
  """

  def index(conn, _) do
    cv_path = if conn.assigns.current_user.cv_path != nil do
      Cv.url({conn.assigns.current_user.cv_path, conn.assigns.current_user}, :original)
      |> String.split_at(13)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    member_cert_path = if conn.assigns.current_user.member_certificate_path != nil do
    MemberCert.url({conn.assigns.current_user.member_certificate_path, conn.assigns.current_user}, :original)
    |> String.split_at(13)
    |> Tuple.delete_at(0)
    |> Tuple.to_list
    |> Enum.join
    end

    user = Repo.get!(User, conn.assigns.current_user.id)
    |> Repo.preload([:facility, {:membership, [:membership_type, :membership_category]}])

    cv_changeset = User.cv_changeset(user)
    parent_account_changeset = User.parent_account_changeset(user)

    if conn.assigns.current_user do
      render conn, "index.html", user: user, cv_path: cv_path, cv_changeset: cv_changeset, parent_account_changeset: parent_account_changeset, member_cert_path: member_cert_path
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end
  end

  def edit(conn, _) do
    facility = Repo.get!(Facility, conn.assigns.current_user.facility_id)

    cv_path = if conn.assigns.current_user.cv_path != nil do
      Cv.url({conn.assigns.current_user.cv_path, conn.assigns.current_user}, :original)
      |> String.split_at(13)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    member_cert_path = if conn.assigns.current_user.member_certificate_path != nil do
    MemberCert.url({conn.assigns.current_user.member_certificate_path, conn.assigns.current_user}, :original)
    |> String.split_at(13)
    |> Tuple.delete_at(0)
    |> Tuple.to_list
    |> Enum.join
    end

    user = Repo.get!(User, conn.assigns.current_user.id)
    |> Repo.preload([:facility, {:membership, [:membership_type, :membership_category]}])

    changeset = User.user_edit_profile_changeset(user)
    cv_changeset = User.cv_changeset(user)
    parent_account_changeset = User.parent_account_changeset(user)

    render(conn, "edit.html", user: user, changeset: changeset, cv_changeset: cv_changeset, parent_account_changeset: parent_account_changeset, facility: facility, cv_path: cv_path,
    member_cert_path: member_cert_path)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.user_edit_profile_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, user.username <> " updated successfully.")
        |> redirect(to: profile_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  defp load_facilities(conn, _) do
    query =
    Facility
    |> Facility.alphebetical
    |> Facility.names_and_ids
    facilities = Repo.all query
    assign(conn, :facilities, facilities)
  end
end
