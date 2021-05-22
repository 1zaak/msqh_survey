defmodule MsqhPortal.PaymentLog do
  use MsqhPortal.Web, :model

  schema "payment_logs" do
    field :rate_year, :integer
    field :rate, Money.Ecto.Type
    field :period, :string
    field :use_period, :integer
    field :state, :string
    field :proof_payment_path, MsqhPortal.ProofPayment.Type
    field :approved_when, :string
    field :receipt_id, :string
    field :receipt_path, MsqhPortal.Receipt.Type
    field :active_from, Timex.Ecto.DateTime
    field :active_to, Timex.Ecto.DateTime
    field :payment_verified, :boolean
    belongs_to :payment_type, MsqhPortal.PaymentType
    belongs_to :membership_type, MsqhPortal.MembershipType
    belongs_to :membership_category, MsqhPortal.MembershipCategory
    belongs_to :member, MsqhPortal.User
    belongs_to :admin, MsqhPortal.User
    belongs_to :facility, MsqhPortal.Facility
    belongs_to :membership, MsqhPortal.Membership
    belongs_to :package, MsqhPortal.Package
    belongs_to :package_discount, MsqhPortal.PackageDiscount

    timestamps()
  end

  @doc """
  Builds a changeset when user creates a proof of payment.
  """
  def proof_payment_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:state, :payment_verified, :payment_type_id,
    :member_id, :membership_category_id, :facility_id, :membership_id, :package_id], [:membership_type_id, :proof_payment_path])
  end

  @doc """
  Builds a changeset when user creates a proof of payment.
  """
  def verify_payment_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:state, :payment_verified, :payment_type_id, :admin_id, :member_id,
    :membership_category_id, :facility_id, :membership_id, :package_id, :active_from, :active_to], [:rate, :proof_payment_path, :receipt_path, :membership_type_id, :approved_when, :receipt_id])
  end
end
