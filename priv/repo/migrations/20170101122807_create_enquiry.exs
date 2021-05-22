defmodule MsqhPortal.Repo.Migrations.CreateEnquiry do
  use Ecto.Migration

  def change do
    create table(:enquiries) do
      add :subject, :string
      add :message, :string
      add :enquiry_attachment_path, :string

      timestamps()
    end

  end
end
