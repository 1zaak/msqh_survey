defmodule MsqhPortal.UserMembershipController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Membership
  alias MsqhPortal.MembershipType
  alias MsqhPortal.MembershipCategory
  alias MsqhPortal.Facility
  alias MsqhPortal.Package
  alias Ecto.Multi 
  alias MsqhPortal.User

  plug :load_membership_categories when action in [:index, :new, :edit, :update, :create]
  plug :load_membership_types when action in [:index, :new, :edit, :update, :create]
  plug :load_facilities when action in [:index, :new, :update, :edit, :create]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end
  @doc """
  Create Membership (MEMBERSHIP table) record with:
  - Renew / Life (from_period & to_period)
  - Membership type (Ordinary, Corporate, Associate Ordinary, Associate Corporate, Life)
  - Change parent (facility)
  - Payment method (Cash, Electronic Transfer, Bank Draft, Postal Order, Cheque, LPO)
  - Upload Proof of Payment
  - Generate unique reference e.g. MSQH/16/45678910XY. Possible: MSQH/{Membership_type}/{parent}/{payment_type}/{datetime}

  Implementation Renew Membership workflow:
  1. Membership Selection (If user already has membership_id, check membership table whether it is still valid or not)
      If expired, create new Membership, else go to particular form e.g. Membership Selection, Payment Selection, etc
      When form is submitted (require Facility, Membership Type & Membership Category), go to Package to get Price & Discount
  2. Payment Selection has price of selected package

  Note: Need to create costs & discounts for each membership type (with relation to parent as well) in Admin
  """
  def index(conn, _) do
    if conn.assigns.current_user.membership_id != nil do
      membership = Repo.get!(Membership, conn.assigns.current_user.membership_id)
      case membership.state do
        "PAYMENT SELECTION" ->
          if membership.payment_verified do
            conn
            |> redirect(to: user_membership_payment_path(conn, :index))
          else
            conn
            |> put_flash(:warning, "Payment is still being verified. Please be patient, we will email you as soon as we are done with the verification process. Thank you!")
            |> redirect(to: user_membership_payment_path(conn, :edit, membership))
          end
        "MEMBERSHIP SELECTION" ->
          conn
          |> redirect(to: user_membership_path(conn, :edit, membership))
        "RECEIPT" ->
          conn
          |> redirect(to: user_membership_payment_path(conn, :show, membership))
      end
    else
      conn
      |> redirect(to: user_membership_path(conn, :new))
    end
  end

  def new(conn, _) do
    changeset = Membership.changeset(%Membership{})
    render(conn, "new.html", user: conn.assigns.current_user, changeset: changeset)
  end

  def edit(conn,  %{"id" => id}) do
    membership = Repo.get!(Membership, id)
    changeset = Membership.edit_selection_changeset(membership)
    case membership.state do
      "PAYMENT SELECTION" ->
        if membership.payment_verified do
          conn
          |> put_flash(:warning, "We have verified your previous payment. If you wish, you can update your membership details and upload another proof of payment, but this will void the previous membership.")
          |> render("edit.html", membership: membership, changeset: changeset)
        else
          changeset = Membership.edit_selection_changeset(membership)
          conn
          |> put_flash(:warning, "You have uploaded a proof of payment and it is still in the verification process. If you wish, you can update your membership details and upload another proof of payment.")
          |> render("edit.html", membership: membership, changeset: changeset)
        end
      "MEMBERSHIP SELECTION" ->
        conn
        |> redirect(to: user_membership_payment_path(conn, :edit, membership))
      "RECEIPT" ->
        conn
        |> put_flash(:warning, "We have verified your previous payment. If you wish, you can update your membership details and upload another proof of payment, but this will void the previous membership.")
        |> render("edit.html", membership: membership, changeset: changeset)
    end
  end

  def create(conn, %{"membership" => membership_params}) do
    package_id = membership_params
    |> set_package_id
    |> List.first

    if (is_nil(package_id)) do
      conn
      |> put_flash(:warning, "Price is not available for this Membership Category and/or Membership Type. Please select a new Membership Category and/or Membership Type.")
      |> redirect(to: user_membership_path(conn, :new))
    else
      membership_with_user_params = membership_params
      |> Enum.into %{"user_id" => conn.assigns.current_user.id}
      |> Enum.into %{"package_id" => package_id}

      transaction = create_membership_transaction(membership_with_user_params)

      case Repo.transaction(transaction) do
        {:ok, %{membership: membership, user: _user}} ->
          conn
          |> put_flash(:info, "Updated membership details successfully")
          |> redirect(to: user_membership_payment_path(conn, :edit, membership))
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          render(conn, "new.html", changeset: failed_value)
      end
    end
  end

  def create_membership_transaction(membership_params) do
    membership_changeset = Membership.update_membership_selection_changeset(%Membership{}, membership_params)

    Multi.new
    |> Multi.insert(:membership, membership_changeset)
    |> Multi.run(:user, fn %{membership: membership} ->
      user = Repo.get!(User, membership.user_id)
      user_changeset = Ecto.Changeset.change user, membership_id: membership.id
      case Repo.update user_changeset do
        {:ok, user} ->
          {:ok, user}
        {:error, user} ->
          {:error, user}
      end
    end)
  end

  def update(conn, %{"id" => id, "membership" => membership_params}) do
    membership = Repo.get!(Membership, id)

    package_id = membership_params
    |> set_package_id
    |> List.first

    membership_with_package_params = membership_params
    |> Enum.into %{"user_id" => conn.assigns.current_user.id}
    |> Enum.into %{"state" => "MEMBERSHIP SELECTION"}
    |> Enum.into %{"package_id" => package_id}

    changeset = Membership.changeset(membership, membership_with_package_params)

    case Repo.update(changeset) do
      {:ok, _membership} ->
        conn
        |> put_flash(:info, "Membership type & category updated successfully")
        |> redirect(to: user_membership_payment_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def set_package_id(membership_params) do
    unless (String.strip(membership_params["membership_type_id"]) == "") do
      filters = [membership_type_id: membership_params["membership_type_id"],
      membership_category_id: membership_params["membership_category_id"],
      facility_id: membership_params["facility_id"]]
    else
      filters = [membership_category_id: membership_params["membership_category_id"],
      facility_id: membership_params["facility_id"]]
    end

    query = from u in Package,
          where: ^filters,
          select: u.id

    Repo.all query
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
