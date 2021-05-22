defmodule MsqhPortal.Package do
  use MsqhPortal.Web, :model

  @doc """
  Lists all prices for each "package" which consists of membership category,
  membership type and annual price for a particular facility.
  """
  schema "packages" do
    field :life_membership_price, Money.Ecto.Type
    field :new_member_annual_price, Money.Ecto.Type
    field :renewal_existing_member_annual_price, Money.Ecto.Type
    belongs_to :facility, MsqhPortal.Facility
    belongs_to :membership_type, MsqhPortal.MembershipType
    belongs_to :membership_category, MsqhPortal.MembershipCategory

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:facility_id],
    [:life_membership_price, :new_member_annual_price, :renewal_existing_member_annual_price, :membership_type_id, :membership_category_id])
  end
end
