defmodule MsqhPortal.Repo.Migrations.RenameFieldsPaymentLogs2 do
  use Ecto.Migration

  def change do
    alter table(:payment_logs) do
      remove :paid_when_verifying
      remove :paid_when_proving
      add :amount_when_verifying, :integer
      add :amount_when_proving, :integer
    end
  end
end
