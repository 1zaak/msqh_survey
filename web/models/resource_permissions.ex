defmodule MsqhPortal.ResourcePermissions do
  use MsqhPortal.Web, :model

  schema "resource_permissions" do
    belongs_to :resource, MsqhPortal.Resource
    belongs_to :allowed_user, MsqhPortal.AllowedUser
    belongs_to :disallowed_user, MsqhPortal.DisallowedUser

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
