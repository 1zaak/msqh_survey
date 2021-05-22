defmodule MsqhPortal.ResourcePermissionsController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.ResourcePermissions

  def index(conn, _params) do
    resource_permissions = Repo.all(ResourcePermissions)
    render(conn, "index.html", resource_permissions: resource_permissions)
  end

  def new(conn, _params) do
    changeset = ResourcePermissions.changeset(%ResourcePermissions{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"resource_permissions" => resource_permissions_params}) do
    changeset = ResourcePermissions.changeset(%ResourcePermissions{}, resource_permissions_params)

    case Repo.insert(changeset) do
      {:ok, _resource_permissions} ->
        conn
        |> put_flash(:info, "Resource permissions created successfully.")
        |> redirect(to: resource_permissions_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    resource_permissions = Repo.get!(ResourcePermissions, id)
    render(conn, "show.html", resource_permissions: resource_permissions)
  end

  def edit(conn, %{"id" => id}) do
    resource_permissions = Repo.get!(ResourcePermissions, id)
    changeset = ResourcePermissions.changeset(resource_permissions)
    render(conn, "edit.html", resource_permissions: resource_permissions, changeset: changeset)
  end

  def update(conn, %{"id" => id, "resource_permissions" => resource_permissions_params}) do
    resource_permissions = Repo.get!(ResourcePermissions, id)
    changeset = ResourcePermissions.changeset(resource_permissions, resource_permissions_params)

    case Repo.update(changeset) do
      {:ok, resource_permissions} ->
        conn
        |> put_flash(:info, "Resource permissions updated successfully.")
        |> redirect(to: resource_permissions_path(conn, :show, resource_permissions))
      {:error, changeset} ->
        render(conn, "edit.html", resource_permissions: resource_permissions, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource_permissions = Repo.get!(ResourcePermissions, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(resource_permissions)

    conn
    |> put_flash(:info, "Resource permissions deleted successfully.")
    |> redirect(to: resource_permissions_path(conn, :index))
  end
end
