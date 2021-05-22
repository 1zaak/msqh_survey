defmodule MsqhPortal.UserMembershipPaymentController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Membership
  alias MsqhPortal.PaymentType
  alias MsqhPortal.ProofPayment
  alias MsqhPortal.PaymentLog
  alias MsqhPortal.Receipt
  alias Ecto.Multi

  plug :load_payment_types when action in [:index, :new, :edit, :update]

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
      conn
      |> redirect(to: user_membership_payment_path(conn, :edit, membership))
    else
      conn
      |> redirect(to: user_membership_payment_path(conn, :new))
    end
  end

  def show(conn,  %{"id" => id}) do
    membership = Repo.get!(Membership, id)
    receipt_path = unless is_nil(membership.receipt_path) do
      Receipt.url({membership.receipt_path, membership}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    else
      nil
    end
    render(conn, "show.html", membership: membership, receipt_path: receipt_path)
  end

  def new(conn, _) do
    changeset = Membership.changeset(%Membership{})
    render(conn, "new.html", user: conn.assigns.current_user, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    membership = Repo.get!(Membership, id)
    |> Repo.preload([:membership_category, :membership_type, :package])

    changeset = Membership.edit_selection_changeset(membership)

    proof_payment_path = unless is_nil(membership.proof_payment_path) do
      ProofPayment.url({membership.proof_payment_path, membership}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    else
      nil
    end

    case membership.state do
      "PAYMENT SELECTION" ->
        if membership.payment_verified do
          conn
          |> put_flash(:warning, "We have verified your previous payment. If you wish, you can update your membership details and upload another proof of payment, but this will void the previous membership.")
          |> render("edit.html", membership: membership, package: membership.package, proof_payment_path: proof_payment_path, changeset: changeset)
        else
          conn
          |> put_flash(:warning, "You have uploaded a proof of payment and it is still in the verification process. If you wish, you can update your membership details and upload another proof of payment.")
          |> render("edit.html", membership: membership, package: membership.package, proof_payment_path: proof_payment_path, changeset: changeset)
        end
      "MEMBERSHIP SELECTION" ->
        if membership.payment_verified do
          conn
          |> put_flash(:warning, "You have uploaded a proof of payment and it is still in the verification process. If you wish, you can update your membership details and upload another proof of payment.")
          |> render("edit.html", membership: membership, package: membership.package, proof_payment_path: proof_payment_path, changeset: changeset)
        else
          conn
          |> put_flash(:info, "You have selected a particular membership. Please upload proof of payment.")
          |> render("edit.html", membership: membership, package: membership.package, proof_payment_path: proof_payment_path, changeset: changeset)
        end
      "RECEIPT" ->
        if membership.payment_verified do
          conn
          |> put_flash(:warning, "We have verified your previous payment. If you wish, you can update your membership details and upload another proof of payment, but this will void the previous membership.")
          |> render("edit.html", membership: membership, package: membership.package, proof_payment_path: proof_payment_path, changeset: changeset)
        else
          conn
          |> put_flash(:info, "We have verified your previous payment. If you wish, you can update your membership details and upload another proof of payment, but this will void the previous membership.")
          |> render("edit.html", membership: membership, package: membership.package, proof_payment_path: proof_payment_path, changeset: changeset)
        end
    end
  end

  def update(conn, %{"id" => id, "membership" => membership_params}) do
    membership = Repo.get!(Membership, id)
    |> Repo.preload([:facility, :membership_type, :membership_category, :package, :payment_type, :user])

    transaction = update_payment_transaction(membership, membership_params)
    case Repo.transaction(transaction) do
      {:ok, %{membership: membership, payment_log: _payment_log}} ->
        conn
        |> put_flash(:info, "Proof of payment uploaded successfully. Please stand by while we verify your payment.")
        |> redirect(to: user_membership_payment_path(conn, :edit, membership))
      {:error, _failed_operation, failed_value, _changes_so_far} ->        
        conn
        |> put_flash(:error, "Error updating payment.")
        |> render("edit.html", membership: membership, package: membership.package, proof_payment_path: nil, changeset: failed_value)
    end
  end

  def update_payment_transaction(membership, membership_params) do
    membership_changeset = Membership.update_payment_selection_changeset(membership, membership_params)
    Multi.new
    |> Multi.update(:membership, membership_changeset)
    |> Multi.run(:payment_log, fn %{membership: membership} ->
      payment_log_changeset = PaymentLog.proof_payment_changeset(%PaymentLog{}, %{"state" => "PAYMENT SELECTION",
      "proof_payment_path" => membership_params["proof_payment_path"], "payment_verified" => false,
      "payment_type_id" => membership_params["payment_type_id"], "member_id" => membership.user_id, "membership_type_id" => membership.membership_type_id,
      "membership_category_id" => membership.membership_category_id, "facility_id" => membership.facility_id, "membership_id" => membership.id,
      "package_id" => membership.package_id})

      case Repo.insert(payment_log_changeset) do
        {:ok, payment_log} ->
          {:ok, payment_log}
        {:error, changeset} ->
          {:error, changeset}
      end
    end)
  end

  defp load_payment_types(conn, _) do
    query =
    PaymentType
    |> PaymentType.alphebetical
    |> PaymentType.names_and_ids
    payment_types = Repo.all query
    assign(conn, :payment_types, payment_types)
  end
end
