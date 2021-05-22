defmodule MsqhPortal.MembershipCategoryController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.MembershipCategory  

  def index(conn, _) do
    membership_categories = Repo.all(MembershipCategory)
    if conn.assigns.current_user do
      render conn, "index.html", membership_categories: membership_categories
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end

  end

  def new(conn, _params) do
    changeset = MembershipCategory.changeset(%MembershipCategory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"membership_category" => membership_category}) do
    changeset = MembershipCategory.changeset(%MembershipCategory{}, membership_category)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Membership category created successfully.")
        |> redirect(to: membership_category_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
