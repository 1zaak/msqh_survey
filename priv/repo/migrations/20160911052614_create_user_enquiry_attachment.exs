defmodule MsqhPortal.Repo.Migrations.CreateUserEnquiryAttachment do
  use Ecto.Migration

  def change do
    create table(:user_enquiry_attachments) do
      add :file_path, :string
      add :user_enquiry_id, references(:user_enquiries, on_delete: :nothing)

      timestamps()
    end
    create index(:user_enquiry_attachments, [:user_enquiry_id])

  end
end
