defmodule MsqhPortal.Repo.Migrations.CreateEnquiryResponse do
  use Ecto.Migration

  def change do
    create table(:enquiry_responses) do
      add :subject, :string
      add :message, :string
      add :enquiry_id, references(:enquiries, on_delete: :nothing)

      timestamps()
    end
    create index(:enquiry_responses, [:enquiry_id])

  end
end
