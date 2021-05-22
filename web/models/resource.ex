defmodule MsqhPortal.Resource do
  use MsqhPortal.Web, :model
  use Arc.Ecto.Schema

  schema "resources" do
    field :title, :string
    field :description, :string
    field :resource_path, MsqhPortal.ResourceAttachment.Type

    belongs_to :facility, MsqhPortal.Facility
    has_many :members, MsqhPortal.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title, :description])
    |> cast_attachments(params, [:resource_path])
  end

  def order_by_title(query) do
    from p in query,
    order_by: [asc: p.title]
  end
end
