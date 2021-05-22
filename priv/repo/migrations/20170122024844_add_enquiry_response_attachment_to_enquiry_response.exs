defmodule MsqhPortal.Repo.Migrations.AddEnquiryResponseAttachmentToEnquiryResponse do
  use Ecto.Migration

  def change do
    alter table(:enquiry_responses) do
      add :enquiry_attachment_path, :string
    end

  end
end
