defmodule MsqhPortal.Repo.Migrations.RenameFieldsPaymentLogs do
  use Ecto.Migration

  def change do
    alter table(:payment_logs) do
      remove :paid_when_proof
      remove :paid_when_verified
      add :paid_when_verifying, :integer
      add :paid_when_proving, :integer
    end
  end
end
