defmodule MsqhPortal.Repo.Migrations.AddReceiptPathToPaymentLogs do
  use Ecto.Migration

  def change do
    alter table(:payment_logs) do
      add :receipt_path, :string
    end
  end
end
