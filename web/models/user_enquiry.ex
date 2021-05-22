defmodule MsqhPortal.UserEnquiry do
  use MsqhPortal.Web, :model

  schema "user_enquiries" do
    field :title, :string
    field :content, :string
    belongs_to :user, MsqhPortal.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content])
    |> validate_required([:title, :content])
  end
end
