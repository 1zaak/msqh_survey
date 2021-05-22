defmodule MsqhPortal.Event do
  use MsqhPortal.Web, :model

  schema "events" do
    field :title, :string
    field :active_from, Timex.Ecto.DateTime
    field :active_to, Timex.Ecto.DateTime
    field :description, :string
    field :location, :string
    field :private, :string
    field :admission_price, Money.Ecto.Type
    has_many :vouchers, MsqhPortal.Voucher

    # @TODO
    # Add field admission_price

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do    
    struct
    |> cast(params, [:title], [:admission_price, :private, :description, :active_from, :active_to, :location])
    |> validate_required([:title, ])
  end

  def order_by_active_from(query) do
    from p in query,
    order_by: [desc: p.active_from]
  end
end
