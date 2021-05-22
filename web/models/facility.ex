defmodule MsqhPortal.Facility do
  use MsqhPortal.Web, :model

  alias MsqhPortal.Package

  schema "facilities" do
    field :facility_name, :string
    field :sector, :string
    has_many :packages, Package
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:facility_name, :inserted_at, :updated_at], [:sector])
    |> validate_required([:facility_name])
  end

  def alphebetical(query) do
    from c in query, order_by: c.facility_name
  end

  def names_and_ids(query) do
    from c in query, select: {c.facility_name, c.id}
  end
end
