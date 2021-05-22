defmodule MsqhPortal.AdminFacilityController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Facility
  alias MsqhPortal.DefaultPrice
  alias MsqhPortal.Package
  alias MsqhPortal.MembershipType
  alias MsqhPortal.MembershipCategory
  alias Ecto.Multi
  use Timex

  plug :load_packages when action in [:show]
  plug :load_membership_categories when action in [:edit_package]
  plug :load_membership_types when action in [:edit_package]
  plug :load_facilities when action in [:edit_package]


  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end

  def index(conn, params) do
    params_with_page_size = Enum.into(%{"page_size" => 12}, params)

    facilities = Facility
    |> Facility.alphebetical
    |> Repo.paginate(params_with_page_size)

    render conn, :index, facilities: facilities
  end

  def new(conn, _params) do
    changeset = Facility.changeset(%Facility{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"facility" => facility_params}) do
    transaction = create_facility(facility_params)

    case Repo.transaction(transaction) do
      {:ok, _result} ->
        conn
        |> put_flash(:info, "Facility and default prices created successfully.")
        |> redirect(to: admin_facility_path(conn, :index))
      {:error, _result} ->
        conn
        |> put_flash(:error, "Facility and default prices fail to be created successfully.")
        |> redirect(to: admin_facility_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    facility = Facility
    |> Repo.get!(id)
    |> Repo.preload([{:packages, [:membership_type, :membership_category]}])

    render(conn, "show.html", facility: facility)
  end

  def edit(conn, %{"id" => id}) do
    facility = Repo.get!(Facility, id)
    |> Repo.preload([{:packages, [:membership_type, :membership_category]}])

    changeset = Facility.changeset(facility)
    render(conn, "edit.html", facility: facility, changeset: changeset)
  end

  def update(conn, %{"id" => id, "facility" => facility_params}) do
    facility = Repo.get!(Facility, id)
    changeset = Facility.changeset(facility, facility_params)

    case Repo.update(changeset) do
      {:ok, facility} ->
        conn
        |> put_flash(:info, "Facility updated successfully.")
        |> redirect(to: facility_path(conn, :show, facility))
      {:error, changeset} ->
        render(conn, "edit.html", facility: facility, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    facility = Repo.get!(Facility, id)

    packages = from p in Package,
     where: p.facility_id == ^id

    unless (is_nil(packages)) do
      Repo.delete_all(packages)
      Repo.delete!(facility)
    else
      Repo.delete!(facility)
    end

    conn
    |> put_flash(:info, "Facility deleted successfully.")
    |> redirect(to: admin_facility_path(conn, :index))
  end

  def create_facility(%{"facility_name" => facility_name}) do
    now = Timezone.convert(Timex.now, "Asia/Kuala_Lumpur")
    facility_changeset = Facility.changeset(%Facility{}, %{"facility_name" => facility_name,
    "inserted_at" => now, "updated_at" => now})

    default_prices = Repo.all DefaultPrice

    Multi.new
    |> Multi.insert(:facility, facility_changeset)
    |> Multi.run(:packages, fn %{facility: facility} ->
      formatted_default_prices = for default_price <- default_prices do
        default_price
        |> Map.take([:life_membership_price, :new_member_annual_price, :renewal_existing_member_annual_price, :membership_category_id, :membership_type_id])
        |> Enum.into(%{facility_id: facility.id, inserted_at: now, updated_at: now})
      end
      IO.inspect formatted_default_prices
      count = Enum.count(formatted_default_prices)
      case Repo.insert_all(Package, formatted_default_prices) do
        {x, packages} when x == count ->
          {:ok, packages}
        {x, packages} when x != count ->
          {:error, packages}
      end
    end)
  end

  def edit_package(conn, %{"id" => id}) do
    package = Repo.get!(Package, id)
    |> Repo.preload([:facility, :membership_type, :membership_category])

    changeset = Package.changeset(package)
    render(conn, "edit_package.html", package: package, changeset: changeset)
  end

  def update_package(conn, %{"id" => id, "package" => package_params}) do
    package = Repo.get!(Package, id)
    |> Repo.preload([:facility, :membership_type, :membership_category])

    changeset = Package.changeset(package, package_params)

    case Repo.update(changeset) do
      {:ok, package} ->
        conn
        |> put_flash(:info, "Package in facility updated successfully.")
        |> redirect(to: admin_facility_path(conn, :show, package.facility))
      {:error, changeset} ->
        render(conn, "edit_package.html", package: package, changeset: changeset)
    end
  end

  defp load_packages(conn, _) do
    facilities = Repo.all from p in Facility,
            preload: [{:packages, [:membership_type, :membership_category]}]

    assign(conn, :facilities, facilities)
  end

  defp load_facilities(conn, _) do
    query =
    Facility
    |> Facility.alphebetical
    |> Facility.names_and_ids
    facilities = Repo.all query
    assign(conn, :facilities, facilities)
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
end
