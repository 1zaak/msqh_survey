defmodule MsqhPortal.Address do
  use MsqhPortal.Web, :model

  schema "addresses" do
    belongs_to :user, MsqhPortal.User
    field :mailing_address, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:mailing_address, :user_id], [])
  end
end
