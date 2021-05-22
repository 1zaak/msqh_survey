defmodule MsqhPortal.DefaultPrice do
  use MsqhPortal.Web, :model

  schema "default_prices" do
    belongs_to :membership_type, MsqhPortal.MembershipType
    belongs_to :membership_category, MsqhPortal.MembershipCategory
    field :life_membership_price, Money.Ecto.Type
    field :new_member_annual_price, Money.Ecto.Type
    field :renewal_existing_member_annual_price, Money.Ecto.Type
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:membership_category_id], [:life_membership_price, :new_member_annual_price, :renewal_existing_member_annual_price, :membership_type_id])
  end
end
