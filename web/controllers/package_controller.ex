defmodule MsqhPortal.PackageController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Package
  alias MsqhPortal.MembershipType
  alias MsqhPortal.MembershipCategory
  alias MsqhPortal.Facility
  plug :load_membership_categories when action in [:index, :new, :update, :edit, :create]
  plug :load_membership_types when action in [:index, :new, :update, :edit, :create]
  plug :load_facilities when action in [:index, :new, :update, :edit, :create]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end

  def index(conn, _params) do
    packages = Repo.all(Package)
    render(conn, "index.html", packages: packages)
  end

  def new(conn, _params) do
    changeset = Package.changeset(%Package{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"package" => package_params}) do    
    changeset = Package.changeset(%Package{}, package_params)

    case Repo.insert(changeset) do
      {:ok, _package} ->
        conn
        |> put_flash(:info, "Package created successfully.")
        |> redirect(to: package_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    package = Repo.get!(Package, id)
    render(conn, "show.html", package: package)
  end

  def edit(conn, %{"id" => id}) do
    package = Repo.get!(Package, id)
    changeset = Package.changeset(package)
    render(conn, "edit.html", package: package, changeset: changeset)
  end

  def update(conn, %{"id" => id, "package" => package_params}) do
    package = Repo.get!(Package, id)
    changeset = Package.changeset(package, package_params)

    case Repo.update(changeset) do
      {:ok, package} ->
        conn
        |> put_flash(:info, "Package updated successfully.")
        |> redirect(to: package_path(conn, :show, package))
      {:error, changeset} ->
        render(conn, "edit.html", package: package, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    package = Repo.get!(Package, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(package)

    conn
    |> put_flash(:info, "Package deleted successfully.")
    |> redirect(to: package_path(conn, :index))
  end

  defp load_membership_types(conn, _) do
    query =
    MembershipType
    |> MembershipType.alphebetical
    |> MembershipType.names_and_ids
    membership_types = Repo.all query
    assign(conn, :membership_types, membership_types)
  end

  defp load_membership_categories(conn, _) do
    query =
    MembershipCategory
    |> MembershipCategory.alphebetical
    |> MembershipCategory.names_and_ids
    membership_categories = Repo.all query
    assign(conn, :membership_categories, membership_categories)
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
