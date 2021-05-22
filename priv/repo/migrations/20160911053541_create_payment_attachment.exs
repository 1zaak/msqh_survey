defmodule MsqhPortal.Repo.Migrations.CreatePaymentAttachment do
  use Ecto.Migration

  def change do
    create table(:payment_attachments) do
      add :file_path, :string
      add :payment_id, references(:payments, on_delete: :nothing)

      timestamps()
    end
    create index(:payment_attachments, [:payment_id])

  end
end
