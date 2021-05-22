defmodule MsqhPortal.MembershipType do
  use MsqhPortal.Web, :model

  @doc """
  Lists all prices for each "package" which consists of membership category,
  membership type and annual price for a particular facility.
  """
  schema "membership_types" do
    field :membership_type_name, :string

    timestamps()
  end

  @required_fields ~w(membership_type_name)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:membership_type_name])
    |> validate_required([:membership_type_name])
  end

  @doc """
  Builds a changeset for editing user or admin.
  """
  def edit_membership_type_changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
  end

  def alphebetical(query) do
    from c in query, order_by: c.membership_type_name
  end

  def names_and_ids(query) do
    from c in query, select: {c.membership_type_name, c.id}
  end
end
