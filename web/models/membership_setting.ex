defmodule MsqhPortal.MembershipSetting do
  use MsqhPortal.Web, :model

  schema "membership_settings" do
    field :days_before_notify_expiration, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:days_before_notify_expiration])
  end
end
