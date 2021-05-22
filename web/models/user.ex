defmodule MsqhPortal.User do
  use MsqhPortal.Web, :model
  use Arc.Ecto.Schema

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :state, :string
    field :active_from, Timex.Ecto.DateTime
    field :active_to, Timex.Ecto.DateTime
    field :current_paid, Money.Ecto.Type
    field :name, :string
    field :title, :string
    field :ic, :string
    field :dob, Ecto.Date
    field :race, :string
    field :gender, :string
    field :nationality, :string
    field :mailing_address, :string
    field :mailing_address_2, :string
    field :phone, :string
    field :professional_designation, :string
    field :qualification, :string
    field :cv_path, MsqhPortal.Cv.Type
    field :member_certificate_path, MsqhPortal.MemberCert.Type
    field :confirm_id, :string
    field :verified, :boolean
    field :approved, :boolean
    field :proof_payment_path, MsqhPortal.ProofPayment.Type
    field :certificate_path, MsqhPortal.MemberCert.Type
    field :receipt_path, MsqhPortal.Receipt.Type
    field :payment_verified, :boolean
    field :profile_updated_at, Timex.Ecto.DateTime
    belongs_to :membership, MsqhPortal.Membership
    belongs_to :facility, MsqhPortal.Facility
    belongs_to :payment_type, MsqhPortal.PaymentType
    belongs_to :membership_type, MsqhPortal.MembershipType
    belongs_to :membership_category, MsqhPortal.MembershipCategory
    belongs_to :package, MsqhPortal.Package
    belongs_to :package_discount, MsqhPortal.PackageDiscount
    has_many :user_vouchers, MsqhPortal.UserVoucher
    has_many :vouchers, MsqhPortal.Voucher

    timestamps()
  end

  @required_fields ~w(username)
  @optional_fields ~w(name title ic dob race gender nationality mailing_address professional_designation
  qualification cv_path member_certificate_path profile_updated_at)

  @doc """
  Builds a changeset for username & email.
  """
  def username_email_changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(username email state confirm_id verified approved), [])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc """
  Builds a changeset for user registration.
  """
  def registration_changeset(model, params \\ %{}) do
    params_with_state = Enum.into(%{"state" => "INACTIVE", "verified" => false, "approved" => false,
    "confirm_id" => random_string(64)}, params)

    model
    |> username_email_changeset(params_with_state)
    |> cast(params, ~w(password name ic facility_id), [])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_required(:facility_id)
    |> put_pass_hash()
    |> validate_confirmation(:password, message: "does not match password!")
  end

  @doc """
  Builds a changeset for admin registration.
  """
  def admin_registration_changeset(model, params \\ %{}) do
    params_with_state = Enum.into(%{"state" => "ADMIN", "verified" => false, "approved" => false,
    "confirm_id" => random_string(64)}, params)

    model
    |> username_email_changeset(params_with_state)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  @doc """
  Builds a changeset for editing user or admin.
  """
  def edit_profile_changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, [:cv_path])
  end

  @doc """
  Builds a changeset for editing user or admin.
  """
  def user_edit_profile_changeset(model, params \\ %{}) do
    now = Timex.now
    params_with_profile_updated_at = Enum.into(%{"profile_updated_at" => now}, params)

    model
    |> cast(params_with_profile_updated_at, @required_fields, @optional_fields)
    |> cast_attachments(params, [:cv_path])
  end

  @doc """
  Builds a changeset for editing user or admin.
  """
  def approve_changeset(model, params \\ %{}) do
    params_with_approved = Enum.into(%{"approved" => true}, params)
    model
    |> cast(params_with_approved, [:approved], [])
  end

  @doc """
  Builds a changeset for editing user or admin.
  """
  def confirm_changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(verified), [])
  end

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def users(query) do
    query |> where([p], p.state == "INACTIVE" or p.state == "ACTIVE" or p.state == "PAID" or p.state == "EXPIRED")
  end

  def order_by_name(query) do
    from p in query,
    order_by: [asc: p.name]
  end

  def order_by_updated_at(query) do
    from p in query,
    order_by: [desc: p.updated_at]
  end

  @doc """
  Builds a changeset for verify payment by admin
  """
  def verify_payment_changeset(struct, params \\ %{}, now, next_year) do
    params_with_active_state = Enum.into(%{"state" => "ACTIVE",
    "active_from" => now, "active_to" => next_year}, params)

    struct
    |> cast(params_with_active_state, [:state, :active_from, :active_to], [:receipt_path, :payment_verified,
    :payment_type_id, :membership_type_id, :membership_category_id, :package_id, :package_discount_id, :certificate_path])
  end

  @doc """
  Builds a changeset for expiring user
  """
  def expire_changeset(struct, params \\ %{}) do
    params_with_active_state = Enum.into(%{"state" => "EXPIRED"}, params)

    struct
    |> cast(params_with_active_state, [:state], [])
  end

  def search_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [], [:username])
  end

  @doc """
  Search function based on this |> http://www.rokkincat.com/blog/2015/05/13/postgres-full-text-search-in-ecto
  """
  def search(query, search_term) do
    from(u in query,
    where: fragment("? % ?", u.username, ^search_term),
    order_by: fragment("similarity(?, ?) DESC", u.username, ^search_term))
  end

  def cv_changeset(struct, params \\ %{}) do
    now = Timex.now
    params_with_profile_updated_at = Enum.into(%{"profile_updated_at" => now}, params)

    struct
    |> cast(params_with_profile_updated_at, [:cv_path], [:profile_updated_at])
  end

  def parent_account_changeset(struct, params \\ %{}) do
    now = Timex.now
    params_with_profile_updated_at = Enum.into(%{"profile_updated_at" => now}, params)

    struct
    |> cast(params_with_profile_updated_at, [:facility_id], [:profile_updated_at])
  end

  @doc """
  Builds a changeset for user registration.
  """
  def change_password_changeset(model, params \\ %{}) do
    params_with_state = Enum.into(%{"verified" => false,
    "confirm_id" => random_string(64)}, params)

    model
    |> cast(params_with_state, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
    |> validate_confirmation(:password, message: "does not match password!")
  end

  @doc """
  Builds a changeset for user registration.
  """
  def ask_email_changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(email), [])    
    |> validate_format(:email, ~r/@/)
  end

  @doc """
  Builds a changeset for seeder.
  """
  def seeder_changeset(model, params \\ %{}) do
    model
    |> cast(params, [], ~w(name ic email professional_designation mailing_address mailing_address_2 phone state username))
  end

  defp put_pass_hash(changeset) do
    case changeset do
       %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
        _ -> changeset
    end
  end
end
