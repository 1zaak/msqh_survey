defmodule MsqhPortal.AdminController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Cv
  alias MsqhPortal.MemberCert
  alias MsqhPortal.User
  alias MsqhPortal.Membership
  alias MsqhPortal.Facility
  alias MsqhPortal.PaymentLog
  alias MsqhPortal.ProofPayment
  alias MsqhPortal.Repo
  alias MsqhPortal.Email
  alias MsqhPortal.Mailer
  alias Ecto.Multi

  plug :load_facilities when action in [:show, :edit, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end
  @doc """
  Display:
  - All users and membership details - user photo, payments made, facility (USER & MEMBERSHIP table)
  - Payments inside Admin Membership page (PAYMENT, PAYMENT ATTACHMENT)
  - All facility (FACILITY table)
  - Send email reminder to renew membership (auto & manual trigger)
  - All enquiries (USER ENQUIRY table)
  - View all rebates (REBATE table)
  Add/Update:
  - *DONE* Approve verified users (Switch user to approved)
  - *DONE* Verify payments and update user's state to Active (USER, PAYMENTS table)
  - Edit facility details and package (FACILITY table & PACKAGE table)
  - Upload Resources
  - Events: send email as well everytime updated (EVENT, CALENDAR table)
  - Reply to user enquiries (USER ENQUIRY table)
  - Add new rebates by giving generated code (REBATE, EVENTS table)
  - Add member certificate when user's state is switched to Active (USER table)
  """

  def index(conn, params) do
    unless is_nil(conn.assigns.current_user) do
      if conn.assigns.current_user.state === "ADMIN" || conn.assigns.current_user.state === "SUPERADMIN" do
        params_with_page_size = Enum.into(%{"page_size" => 12}, params)

        users = User
        |> User.users
        |> User.order_by_updated_at
        |> preload([:facility, {:membership, [:membership_type, :membership_category]}])
        |> Repo.paginate(params_with_page_size)
        
        search_changeset = User.search_changeset(%User{})

        render conn, :index, users: users, search_changeset: search_changeset
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

  def search(conn, %{"user" => search_terms}) do
    users = User
    |> User.search(search_terms["username"])
    |> User.users
    |> User.order_by_updated_at
    |> preload([:facility, {:membership, [:membership_type, :membership_category]}])
    |> Repo.paginate(%{"page_size" => 12})

    search_changeset = User.search_changeset(%User{})

    render conn, :index, users: users, search_changeset: search_changeset
  end

  def new(conn, _params) do
    changeset = User.admin_registration_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.admin_registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        Email.verify_email(user.email, user.confirm_id) |> Mailer.deliver_later
        conn
        |> put_flash(:info, "Please confirm your email address: " <> user.email)
        |> redirect(to: login_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def approve(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.approve_changeset(user)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, user.username <> " updated successfully.")
        |> redirect(to: admin_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def verify(conn, %{"membership" => membership_params}) do
    IO.inspect membership_params
    membership = Repo.get!(Membership, membership_params["membership_id"])
    |> Repo.preload([:facility, :membership_type, :membership_category, :package, :payment_type, {:user, [:facility, {:membership, [:membership_type, :membership_category]}]}])

    now = Timex.now

    unless is_nil(membership.user.active_to) do
      remaining = Timex.diff(membership.user.active_to, Timex.now, :days)
      next_year = Timex.add(Timex.now, Timex.Duration.from_days(remaining + 365))
    else
      next_year = Timex.add(Timex.now, Timex.Duration.from_days(365))
    end

    admin = conn.assigns.current_user

    # To add 1) upload receipt, 2) Receipt ID, 3) Approved When..
    certificate_temp_path = create_certificate(now, next_year, membership.user, membership)

    transaction = verify_transaction(membership, membership.user, admin, now, next_year, membership_params["receipt_path"], certificate_temp_path, membership_params["approved_when"], membership_params["receipt_id"])

    case Repo.transaction(transaction) do
      {:ok, %{verify_payment_membership: membership, verify_payment_user: _user, verify_payment_log: _payment_log, update_receipt_path: _update_receipt_path}} ->
        conn
        |> put_flash(:info, "Payment verified successfully.")
        |> redirect(to: admin_path(conn, :show, membership.user_id))
      {:error, %{verify_payment_membership: membership, verify_payment_user: _user, verify_payment_log: _payment_log, update_receipt_path: _update_receipt_path}} ->
        render(conn, "show.html", user: membership.user_id)
    end
  end

  def create_receipt(now, next_year, membership) do
    unless is_nil(membership.membership_type) do
      receipt = "<html>
        <body><p>Receipt date/time: #{now}</p>
          <p>Membership expiration date: #{next_year}</p>
          <p>Facility: #{membership.facility.facility_name}</p>
          <p>Membership Category: #{membership.membership_category.membership_category_name}</p>
          <p>Membership Type: #{membership.membership_type.membership_type_name}</p>
        </body>
      </html>"
    else
      receipt = "<html>
        <body><p>Receipt date/time: #{now}</p>
          <p>Membership expiration date: #{next_year}</p>
          <p>Facility: #{membership.facility.facility_name}</p>
          <p>Membership Category: #{membership.membership_category.membership_category_name}</p>
        </body>
      </html>"
    end

    PdfGenerator.generate!(receipt, page_size: "A4")
  end

  def create_certificate(now, next_year, user, membership) do
    receipt = MsqhPortal.TemplateHelper.certificate(now, next_year, user, membership)
    PdfGenerator.generate!(receipt, page_size: "A4")
  end

  def show(conn, params) do
    user = Repo.get!(User, params["id"])
    |> Repo.preload([:facility, :membership_type, :membership_category, {:membership, [:facility, :membership_type, :membership_category]}])

    non_preload_user = Repo.get!(User, params["id"])

    memberships = Repo.all from m in Membership,
    where: m.user_id == ^user.id,
    preload: [:membership_category, :membership_type, :package, :package_discount, :facility],
    order_by: [desc: m.updated_at]

    payment_logs = PaymentLog
    |> where([member_id: ^user.id])
    |> order_by(desc: :updated_at)
    |> preload([:membership_type, :membership_category, :package, :member, :admin, :facility, :membership, :payment_type])
    |> Repo.paginate(%{"page_size" => 5, "page" => params["page"]})

    cv_path = if user.cv_path != nil do
      Cv.url({user.cv_path, user}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    member_cert_path = if user.member_certificate_path != nil do
      MemberCert.url({user.member_certificate_path, user}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    changeset = User.edit_profile_changeset(user)

    unless is_nil(non_preload_user.membership_id) do
      membership_info = non_preload_user
      |> load_membership_info

      unless is_nil(membership_info) do
        IO.puts "1"
        proof_payment_path = if membership_info.membership.proof_payment_path != nil do
          ProofPayment.url({membership_info.membership.proof_payment_path, membership_info.membership}, :original)
          |> String.split_at(12)
          |> Tuple.delete_at(0)
          |> Tuple.to_list
          |> Enum.join
        end
      else
        IO.puts "2"
        proof_payment_path = nil
      end

      unless is_nil(membership_info.membership.active_from) && is_nil(membership_info.membership.active_to) do
        IO.puts "3"
        {:ok, active_from} = Timex.format(membership_info.membership.active_from, "%b %d, %Y", :strftime)
        {:ok, active_to} = Timex.format(membership_info.membership.active_to, "%b %d, %Y", :strftime)
        conn
        |> render "show.html", user: user, active_from: active_from,
        active_to: active_to, membership_info: membership_info, proof_payment_path: proof_payment_path,
        cv_path: cv_path, member_cert_path: member_cert_path, memberships: memberships, payment_logs: payment_logs, changeset: changeset
      else
        membership_changeset = Membership.verify_payment_changeset(membership_info.membership, %{}, nil, nil)
        IO.inspect membership_changeset
        IO.puts "4"
        conn
        |> render "show.html", user: user, membership_info: membership_info, proof_payment_path: proof_payment_path,
        cv_path: cv_path, member_cert_path: member_cert_path, memberships: memberships, payment_logs: payment_logs, changeset: changeset,
        membership_changeset: membership_changeset
      end
    else
      IO.puts "5"
      conn
      |> render "show.html", user: user, cv_path: cv_path, memberships: nil, payment_logs: nil, member_cert_path: nil, changeset: changeset
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    cv_path = if user.cv_path != nil do
      Cv.url({user.cv_path, user}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    member_cert_path = if user.member_certificate_path != nil do
      MemberCert.url({user.member_certificate_path, user}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    changeset = User.edit_profile_changeset(user)

    render(conn, "edit.html", user: user, cv_path: cv_path, member_cert_path: member_cert_path, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    |> Repo.preload([:facility, :membership_type, :membership_category, {:membership, [:membership_type, :membership_category]}])
    changeset = User.edit_profile_changeset(user, user_params)

    cv_path = if user.cv_path != nil do
      Cv.url({user.cv_path, user}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    member_cert_path = if user.member_certificate_path != nil do
      MemberCert.url({user.member_certificate_path, user}, :original)
      |> String.split_at(12)
      |> Tuple.delete_at(0)
      |> Tuple.to_list
      |> Enum.join
    end

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, user.username <> " updated successfully.")
        |> render "edit.html", user: user, cv_path: cv_path, member_cert_path: member_cert_path, changeset: changeset
      {:error, changeset} ->
        render(conn, "edit.html", user: user, cv_path: cv_path, member_cert_path: member_cert_path, changeset: changeset)
    end
  end

  def verify_transaction(membership, user, admin, now, next_year, receipt_path, certificate_temp_path, approved_when, receipt_id) do
    rate = unless is_nil(membership.rate) do
      membership.rate
    else
      nil
    end

    payment_log_changeset = PaymentLog.verify_payment_changeset(%PaymentLog{}, %{"state" => "RECEIPT",
    "active_from" => now, "active_to" => next_year, "payment_verified" => true, "payment_type_id" => membership.payment_type_id,
    "member_id" => membership.user_id, "admin_id" => admin.id, "membership_type_id" => membership.membership_type_id,
    "membership_category_id" => membership.membership_category_id, "facility_id" => membership.facility_id,
    "membership_id" => membership.id, "package_id" => membership.package_id, "rate" => rate,
    "receipt_path" => receipt_path, "approved_when" => approved_when, "receipt_id" => receipt_id})

    unless is_nil(membership.membership_type) do
      user_params = %{"payment_verified" => true, "payment_type_id" => membership.payment_type.id,
      "membership_type_id" => membership.membership_type.id, "membership_category_id" => membership.membership_category.id,
      "package_id" => membership.package.id, "receipt_path" => receipt_path, "approved_when" => approved_when, "receipt_id" => receipt_id,
      "certificate_path" => %Plug.Upload{content_type: "application/pdf", filename: "cert-#{membership.id}.pdf", path: certificate_temp_path}}
    else
      user_params = %{"payment_verified" => true, "payment_type_id" => membership.payment_type.id, "membership_category_id" => membership.membership_category.id,
      "package_id" => membership.package.id, "receipt_path" => receipt_path,
      "certificate_path" => %Plug.Upload{content_type: "application/pdf", filename: "cert-#{membership.id}.pdf", path: certificate_temp_path}}
    end


    Multi.new
    |> Multi.update(:verify_payment_membership, Membership.verify_payment_changeset(membership, %{"certificate_path" => %Plug.Upload{content_type: "application/pdf", filename: "cert-#{membership.id}.pdf", path: certificate_temp_path}, "approved_when" => approved_when, "receipt_id" => receipt_id}, now, next_year))
    |> Multi.update(:verify_payment_user, User.verify_payment_changeset(user, user_params, now, next_year))
    |> Multi.insert(:verify_payment_log, payment_log_changeset)
    |> Multi.run(:update_receipt_path, fn %{verify_payment_membership: verify_payment_membership, verify_payment_user: _verify_payment_user, verify_payment_log: _verify_payment_log} ->
      changeset = Membership.add_receipt_path_changeset(%Membership{id: verify_payment_membership.id}, %{ receipt_path: receipt_path})
      case Repo.update(changeset) do
        {:ok, membership} ->
          {:ok, membership}
        {:error, changeset} ->
          {:error, changeset}
      end
    end)
  end

  def change(conn, %{"id" => user_id}) do
    user = Repo.get(User, user_id)
    changeset = User.change_password_changeset(user)

    render(conn, "change.html", changeset: changeset, user: user)
  end

  def change_password(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.change_password_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        MsqhPortal.Email.verify_email(user.email, user.confirm_id) |> MsqhPortal.Mailer.deliver_later
        conn
        |> put_flash(:info, "Please verify your new password: " <> user.email)
        |> redirect(to: admin_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "change.html", user: user, changeset: changeset)
    end
  end

  def load_membership_info(user) do
    membership = Repo.get(Membership, user.membership_id)
    |> Repo.preload([:membership_type, :membership_category])

    %{membership: membership}
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
