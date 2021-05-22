defmodule MsqhPortal.Voucher do
  use MsqhPortal.Web, :model

  schema "vouchers" do
    field :code, :string
    field :discount_percent, :float
    field :expire_at, Timex.Ecto.DateTime
    field :valid, :boolean, default: false
    belongs_to :event, MsqhPortal.Event    
    has_many :user_vouchers, MsqhPortal.UserVoucher

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:discount_percent], [:code, :valid, :event_id, :expire_at])
    |> validate_required([:discount_percent])
    |> validate_number(:discount_percent, greater_than: 0, less_than: 101)
    |> unique_constraint(:code)
  end
end
