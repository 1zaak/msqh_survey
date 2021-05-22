defmodule MsqhPortal.DefaultPriceController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.DefaultPrice
  alias MsqhPortal.MembershipType
  alias MsqhPortal.MembershipCategory

  plug :load_membership_categories when action in [:edit, :new]
  plug :load_membership_types when action in [:edit, :new]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end

  @doc """
  - Sets default prices for membership type and membership category
  - When creating new Facility, these default prices will populate the corresponding Package
  """

  def index(conn, params) do
    unless is_nil(conn.assigns.current_user) do
      if conn.assigns.current_user.state === "ADMIN" || conn.assigns.current_user.state === "SUPERADMIN" do
        default_prices = Repo.all from p in DefaultPrice,
        preload: [:membership_type, :membership_category]

        render conn, :index, default_prices: default_prices

      else
        conn
        |> put_flash(:error, "Only admin can access this page.")
        |> redirect(to: default_price_path(conn, :index))
      end
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = DefaultPrice.changeset(%DefaultPrice{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"default_price" => default_price_params}) do
    changeset = DefaultPrice.changeset(%DefaultPrice{}, default_price_params)

    case Repo.insert(changeset) do
      {:ok, _facility} ->
        conn
        |> put_flash(:info, "Default price created successfully.")
        |> redirect(to: default_price_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    default_price = Repo.get!(DefaultPrice, id)
    conn
    |> render "show.html", default_price: default_price

  end

  def edit(conn, %{"id" => id}) do
    default_price = Repo.get!(DefaultPrice, id)
    |> Repo.preload [:membership_type, :membership_category]

    changeset = DefaultPrice.changeset(default_price)

    render(conn, "edit.html", default_price: default_price, changeset: changeset)
  end

  def update(conn, %{"id" => id, "default_price" => default_price_params}) do
    default_price = Repo.get!(DefaultPrice, id)
    changeset = DefaultPrice.changeset(default_price, default_price_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Default price updated successfully.")
        |> redirect(to: default_price_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", default_price: default_price, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    DefaultPrice
    |> Repo.get!(id)
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Default price deleted successfully.")
    |> redirect(to: default_price_path(conn, :index))
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
