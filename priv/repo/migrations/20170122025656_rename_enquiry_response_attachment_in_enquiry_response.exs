defmodule MsqhPortal.Repo.Migrations.RenameEnquiryResponseAttachmentInEnquiryResponse do
  use Ecto.Migration

  def change do
    alter table(:enquiry_responses) do
      remove :enquiry_attachment_path
      add :enquiry_response_attachment_path, :string
    end
  end
end
