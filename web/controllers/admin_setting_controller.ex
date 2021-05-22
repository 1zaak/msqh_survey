defmodule MsqhPortal.AdminSettingController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.MembershipCategory
  alias MsqhPortal.MembershipType
  alias MsqhPortal.DefaultPrice
  alias MsqhPortal.Facility
  alias MsqhPortal.PaymentType
  alias MsqhPortal.MembershipSetting
  alias MsqhPortal.User

  plug :load_membership_categories when action in [:index]
  plug :load_membership_types when action in [:index]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end

  @doc """
  Send email when:
  - Verifying user/admin after they have registered
  - {VARIABLE} day(s) before user membership is expired
  - When user creates a new ENQUIRY
  - When user creates a new PAYMENT / MEMBERSHIP
  - When new EVENT is created (Optional)
  """
  def index(conn, _) do
    payment_type_changeset = PaymentType.changeset(%PaymentType{})
    membership_category_changeset = MembershipCategory.changeset(%MembershipCategory{})
    membership_type_changeset = MembershipType.changeset(%MembershipType{})
    default_price_changeset = DefaultPrice.changeset(%DefaultPrice{})
    register_changeset = User.admin_registration_changeset(%User{})

    membership_categories = Repo.all(MembershipCategory)
    membership_types = Repo.all(MembershipType)
    payment_types = Repo.all(PaymentType)
    default_prices = Repo.all from m in DefaultPrice, preload: [:membership_category, :membership_type]
    facilities = Repo.all(Facility)
    membership_setting = Repo.get!(MembershipSetting, 1)
    membership_setting_changeset = MembershipSetting.changeset(membership_setting)
    admins = Repo.all from m in User, where: m.state == "ADMIN", order_by: [asc: m.username]

    render(conn, :index, payment_type_changeset: payment_type_changeset, membership_categories: membership_categories,
    membership_types: membership_types, default_prices: default_prices, payment_types: payment_types, facilities: facilities,
    membership_category_changeset: membership_category_changeset, membership_type_changeset: membership_type_changeset,
    default_price_changeset: default_price_changeset, membership_setting_changeset: membership_setting_changeset, admins: admins,
    register_changeset: register_changeset)
  end

  def edit_expiration_notification(conn, %{"membership_setting" => membership_setting_params}) do
    changeset = MembershipSetting.changeset(%MembershipSetting{id: 1}, membership_setting_params)

    case Repo.update(changeset) do
      {:ok, _membership_setting} ->
        conn
        |> put_flash(:info, "Notification setting created successfully.")
        |> redirect(to: admin_setting_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def create_membership_type(conn, %{"membership_type" => membership_type}) do
    changeset = MembershipType.changeset(%MembershipType{}, membership_type)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Membership type created successfully.")
        |> redirect(to: admin_setting_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def create_membership_category(conn, %{"membership_category" => membership_category}) do
    changeset = MembershipCategory.changeset(%MembershipCategory{}, membership_category)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        IO.puts "inside create membership category"
        conn
        |> put_flash(:info, "Membership category created successfully.")
        |> redirect(to: admin_setting_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def create_payment_type(conn, %{"payment_type" => payment_type_params}) do
    changeset = PaymentType.changeset(%PaymentType{}, payment_type_params)

    case Repo.insert(changeset) do
      {:ok, _facility} ->
        conn
        |> put_flash(:info, "Payment Type created successfully.")
        |> redirect(to: admin_setting_path(conn, :index))
      {:error, _changeset} ->
        payment_type_changeset = PaymentType.changeset(%PaymentType{})
        render(conn, "index.html", payment_type_changeset: payment_type_changeset)
    end
  end

  def create_default_price(conn, %{"default_price" => default_price_params}) do
    changeset = DefaultPrice.changeset(%DefaultPrice{}, default_price_params)

    case Repo.insert(changeset) do
      {:ok, _facility} ->
        conn
        |> put_flash(:info, "Default price created successfully.")
        |> redirect(to: admin_setting_path(conn, :index))
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def update_payment_type(conn, %{"id" => id, "payment_type" => payment_type_params}) do
    payment_type = Repo.get!(PaymentType, id)
    changeset = PaymentType.changeset(payment_type, payment_type_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Payment Type updated successfully.")
        |> redirect(to: admin_setting_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", payment_type: payment_type, changeset: changeset)
    end
  end

  def delete_admin(conn, %{"id" => id}) do
    admin = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(admin)

    conn
    |> put_flash(:info, "Admin deleted successfully.")
    |> redirect(to: admin_setting_path(conn, :index))
  end

  def create_admin(conn, %{"user" => user_params}) do
    changeset = User.admin_registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        MsqhPortal.Email.verify_email(user.email, user.confirm_id) |> MsqhPortal.Mailer.deliver_later
        conn
        |> put_flash(:info, "Please confirm your email address: " <> user.email)
        |> redirect(to: admin_setting_path(conn, :index))
      {:error, _changeset} ->
        render(conn, "index.html")
    end
  end

  defp load_membership_types(conn, _) do
    query =
    MembershipType
    |> MembershipType.alphebetical
    |> MembershipType.names_and_ids
    membership_types_list = Repo.all query
    assign(conn, :membership_types_list, membership_types_list)
  end

  defp load_membership_categories(conn, _) do
    query =
    MembershipCategory
    |> MembershipCategory.alphebetical
    |> MembershipCategory.names_and_ids
    membership_categories_list = Repo.all query
    assign(conn, :membership_categories_list, membership_categories_list)
  end
end
