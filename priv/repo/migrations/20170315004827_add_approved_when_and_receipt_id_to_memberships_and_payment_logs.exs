defmodule MsqhPortal.Repo.Migrations.AddApprovedWhenAndReceiptIdToMembershipsAndPaymentLogs do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :receipt_id, :string
      add :approved_when, :string
    end

    alter table(:payment_logs) do      
      add :receipt_id, :string
      add :approved_when, :string
    end
  end
end
