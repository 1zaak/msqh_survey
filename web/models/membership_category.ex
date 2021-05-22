defmodule MsqhPortal.MembershipCategory do
  use MsqhPortal.Web, :model

  @doc """
  Lists all prices for each "package" which consists of membership category,
  membership type and annual price for a particular facility.
  """
  schema "membership_categories" do
    field :membership_category_name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:membership_category_name])
    |> validate_required([:membership_category_name])
  end

  def alphebetical(query) do
    from c in query, order_by: c.membership_category_name
  end

  def names_and_ids(query) do
    from c in query, select: {c.membership_category_name, c.id}
  end
end
