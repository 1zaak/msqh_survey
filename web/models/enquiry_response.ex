defmodule MsqhPortal.EnquiryResponse do
  use MsqhPortal.Web, :model

  schema "enquiry_responses" do
    field :subject, :string
    field :message, :string
    field :user_read, :boolean
    field :user_replied, :boolean
    field :admin_read, :boolean
    field :admin_replied, :boolean
    field :enquiry_response_attachment_path, MsqhPortal.EnquiryResponseAttachment.Type
    belongs_to :enquiry, MsqhPortal.Enquiry
    belongs_to :member, MsqhPortal.User
    belongs_to :admin, MsqhPortal.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:message, :enquiry_id], [:member_id, :admin_id, :user_read, :user_replied, :admin_read, :admin_replied, :enquiry_response_attachment_path])
    |> validate_required([:message])
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def admin_changeset(struct, params \\ %{}, admin_id \\ nil, member_id \\ nil) do
    params_with_admin_id = Enum.into(%{"admin_id" => admin_id, "member_id" => member_id, "admin_read" => true, "admin_replied" => true,
    "user_read" => false, "user_replied" => false}, params)
    struct
    |> cast(params_with_admin_id, [:message, :enquiry_id], [:user_read, :user_replied, :admin_read, :admin_replied, :admin_id, :member_id, :enquiry_response_attachment_path])
    |> validate_required([:message])
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def member_changeset(struct, params \\ %{}, member_id \\ nil) do
    params_with_member_id = Enum.into(%{"member_id" => member_id, "admin_read" => false, "admin_replied" => false,
    "user_read" => true, "user_replied" => true}, params)
    struct
    |> cast(params_with_member_id, [:message, :enquiry_id], [:user_read, :user_replied, :admin_read, :admin_replied,
    :member_id, :enquiry_response_attachment_path])
    |> validate_required([:message])
  end

  def reset_member_read_changeset(struct, params \\ %{}, member_id \\ nil, admin_id \\ nil) do
    params_with_member_id = Enum.into(%{"member_id" => member_id, "admin_id" => admin_id, "admin_read" => false,
    "admin_replied" => false, "user_read" => true, "user_replied" => true}, params)
    struct
    |> cast(params_with_member_id, [], [:user_read, :user_replied, :admin_read, :admin_replied, :enquiry_response_attachment_path])
  end

  def reset_admin_read_changeset(struct, params \\ %{}, member_id \\ nil, admin_id \\ nil) do
    params_with_member_id = Enum.into(%{"member_id" => member_id, "admin_id" => admin_id, "admin_read" => false,
    "admin_replied" => false, "user_read" => true, "user_replied" => true}, params)
    struct
    |> cast(params_with_member_id, [], [:user_read, :user_replied, :admin_read, :admin_replied, :enquiry_response_attachment_path])
  end
end
