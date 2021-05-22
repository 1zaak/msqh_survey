defmodule MsqhPortal.UserController do
  use MsqhPortal.Web, :controller
  alias MsqhPortal.User
  alias MsqhPortal.Facility
  alias MsqhPortal.Mailer
  alias MsqhPortal.Email
  alias MsqhPortal.PaymentLog
  alias MsqhPortal.Event
  alias MsqhPortal.Resource
  alias MsqhPortal.UserVoucher

  plug :load_facilities when action in [:new, :create]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end

  @doc """
  Dashboard for user.
  Display:
  - *DONE* End of subscription (active_to in USER table), last payment (current_paid & active_from in USER table),
  - Events (EVENT table),
  - Resources (filepath to PDFs & RESOURCE table)
  - Replies from enquiries (USER_ENQUIRY table)
  """
  def index(conn, _) do
    if conn.assigns.current_user do
      user = Repo.get!(User, conn.assigns.current_user.id)
      |> Repo.preload([:facility, {:membership, [:membership_type, :membership_category]}])

      payment_history = PaymentLog
      |> where([member_id: ^user.id])
      |> order_by(desc: :updated_at)
      |> preload([:membership, :membership_category, :membership_type, :package, :package_discount, :facility, :admin, :payment_type])
      |> Repo.paginate(%{"page_size" => 5})

      now = Timex.now()
      events = Event
      |> where([e], e.active_from > ^now)
      |> Event.order_by_active_from
      |> Repo.paginate(%{"page_size" => 5})

      resources = Resource
      |> Resource.order_by_title
      |> Repo.paginate(%{"page_size" => 5})

      user_vouchers = Repo.all(from v in UserVoucher,
      where: v.user_id == ^user.id and v.expire_at > ^now,
      order_by: [desc: v.updated_at],
      preload: [{:voucher, [:event]}])
      
      render conn, "index.html", user: user, payment_history: payment_history, events: events, resources: resources, user_vouchers: user_vouchers
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end

  end

  def new(conn, _params) do
    changeset = User.username_email_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    # User activation
    # activation_url(MsqhPortal.Endpoint, :confirm, confirm_id: confirm_id)
    changeset = User.registration_changeset(%User{}, user_params)

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

  defp load_facilities(conn, _) do
    query =
    Facility
    |> Facility.alphebetical
    |> Facility.names_and_ids
    facilities = Repo.all query
    assign(conn, :facilities, facilities)
  end
end
