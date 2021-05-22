defmodule MsqhPortal.PhoneNumber do
  use MsqhPortal.Web, :model

  schema "phone_numbers" do
    belongs_to :user, MsqhPortal.User
    field :phone_type, :string
    field :phone_number, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:phone_number, :user_id], [:phone_type])
  end
end
