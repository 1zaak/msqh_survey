defmodule MsqhPortal.UserVoucher do
  use MsqhPortal.Web, :model

  schema "user_vouchers" do
    belongs_to :user, MsqhPortal.User
    belongs_to :voucher, MsqhPortal.Voucher
    field :expire_at, Timex.Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :voucher_id], [])
  end
end
