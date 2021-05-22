defmodule MsqhPortal.Membership do
  use MsqhPortal.Web, :model

  use Arc.Ecto.Schema
  @doc """
  :membership_category means either:
  - Renew Membership
  - Upgrade Life Membership

  :membership_type means either:
  - Ordinary Membership
  - Corporate Membership
  - Associate Ordinary Membership
  - Associate Corporate Membership
  - Life Membership

  :payment_type means either:
  - Cash
  - Electronic Transfer
  - Bank Draft
  - Postal Order
  - Cheque
  - LPO

  :state means:
  1 => Membership Selection // go to Package table to get price & discount
  2 => Payment Selection
  3 => Proof of Payment
  4 => Receipt / Active
  5 => Expired
  """
  schema "memberships" do
    field :rate_year, :integer
    field :rate, Money.Ecto.Type
    field :period, :string
    field :use_period, :integer
    field :state, :string
    field :proof_payment_path, MsqhPortal.ProofPayment.Type
    field :certificate_path, MsqhPortal.MemberCert.Type
    field :approved_when, :string
    field :receipt_id, :string
    field :receipt_path, MsqhPortal.Receipt.Type
    field :active_from, Timex.Ecto.DateTime
    field :active_to, Timex.Ecto.DateTime
    field :payment_verified, :boolean
    belongs_to :payment_type, MsqhPortal.PaymentType
    belongs_to :membership_type, MsqhPortal.MembershipType
    belongs_to :membership_category, MsqhPortal.MembershipCategory
    belongs_to :user, MsqhPortal.User
    belongs_to :facility, MsqhPortal.Facility
    belongs_to :package, MsqhPortal.Package
    belongs_to :package_discount, MsqhPortal.PackageDiscount

    timestamps()
  end

  @required_fields ~w(membership_category_id facility_id user_id package_id state)
  @required_payment_fields ~w(membership_category_id facility_id user_id package_id state payment_verified)
  @optional_fields ~w(membership_type_id rate_year rate period use_period payment_type_id proof_payment_path active_from active_to package_id payment_verified)
  @doc """
  Builds a changeset for normal membership.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required([:membership_type_id, :membership_category_id, :facility_id, :user_id])
  end

  @doc """
  Builds a changeset for edit page of membership category & membership type selection.
  """
  def edit_selection_changeset(struct, params \\ %{}) do
     struct
     |> cast(params, @required_fields, @optional_fields)
  end

  @doc """
  Builds a changeset for normal membership.
  """
  def update_membership_selection_changeset(struct, params \\ %{}) do
    params_with_state = Enum.into(%{"state" => "MEMBERSHIP SELECTION", "payment_verified" => false}, params)
    struct
    |> cast(params_with_state, @required_fields, @optional_fields)
    |> validate_required([:membership_category_id, :facility_id, :user_id])
  end

  @doc """
  Builds a changeset for update payment by user membership.
  """
  def update_payment_selection_changeset(struct, params \\ %{}) do
    params_with_state = Enum.into(%{"state" => "PAYMENT SELECTION", "payment_verified" => false}, params)
    struct
    |> cast(params_with_state, @required_payment_fields, @optional_fields)
    |> validate_required([:payment_type_id, :proof_payment_path, :payment_verified, :membership_category_id, :facility_id, :user_id])
  end

  @doc """
  Builds a changeset for verify payment by admin
  """
  def verify_payment_changeset(struct, params \\ %{}, now, next_year) do
    params_with_verified = Enum.into(%{"state" => "RECEIPT", "payment_verified" => true,
    "active_from" => now, "active_to" => next_year}, params)

    struct
    |> cast(params_with_verified, [:payment_verified, :state, :active_from, :active_to], [:certificate_path, :approved_when, :receipt_id])
  end

  @doc """
  Builds a changeset for verify payment by admin
  """
  def add_receipt_path_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(receipt_path))
  end
end
