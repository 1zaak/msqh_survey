defmodule MsqhPortal.Enquiry do
  use MsqhPortal.Web, :model
  use Arc.Ecto.Schema

  schema "enquiries" do
    field :subject, :string
    field :message, :string
    field :user_read, :boolean
    field :user_replied, :boolean
    field :admin_read, :boolean
    field :admin_replied, :boolean
    field :enquiry_attachment_path, MsqhPortal.EnquiryAttachment.Type

    belongs_to :member, MsqhPortal.User
    has_many :enquiry_responses, MsqhPortal.EnquiryResponse

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    params_with_state = Enum.into(%{"admin_read" => false, "admin_replied" => false,
    "user_read" => true, "user_replied" => true}, params)

    struct
    |> cast(params_with_state, [:message, :member_id], [:subject, :user_read, :user_replied, :admin_read, :admin_replied])
    |> validate_required([:message])
    |> cast_attachments(params_with_state, [:enquiry_attachment_path])
  end

  def admin_replied_changeset(struct, params \\ %{}) do
    params_with_state = Enum.into(%{"admin_read" => true, "admin_replied" => true,
    "user_read" => false, "user_replied" => false}, params)

    struct
    |> cast(params_with_state, [], [:user_read, :user_replied, :admin_read, :admin_replied])
  end
end
