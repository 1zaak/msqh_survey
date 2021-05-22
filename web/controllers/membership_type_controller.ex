defmodule MsqhPortal.MembershipTypeController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.MembershipType

  def index(conn, _) do
    membership_types = Repo.all(MembershipType)
    if conn.assigns.current_user do
      render conn, "index.html", membership_types: membership_types
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    membership_type = Repo.get!(MembershipType, id)
    render(conn, "show.html", membership_type: membership_type)
  end

  def new(conn, _params) do
    changeset = MembershipType.changeset(%MembershipType{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"membership_type" => membership_type}) do
    changeset = MembershipType.changeset(%MembershipType{}, membership_type)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Membership type created successfully.")
        |> redirect(to: membership_type_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    membership_type = Repo.get!(MembershipType, id)
    changeset = MembershipType.changeset(membership_type)
    render(conn, "edit.html", membership_type: membership_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "membership_type" => membership_type_params}) do
    membership_type = Repo.get!(MembershipType, id)
    changeset = MembershipType.edit_membership_type_changeset(membership_type, membership_type_params)

    case Repo.update(changeset) do
      {:ok, _membership_type} ->
        conn
        |> put_flash(:info,  "Membership Type updated successfully.")
        |> redirect(to: membership_type_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", membership_type: membership_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    membership_type = Repo.get!(MembershipType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(membership_type)

    conn
    |> put_flash(:info, "Membership Type deleted successfully.")
    |> redirect(to: membership_type_path(conn, :index))
  end
end
