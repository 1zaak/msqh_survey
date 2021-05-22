defmodule MsqhPortal.Repo.Migrations.EditFieldsForPaymentLogs do
  use Ecto.Migration

  def change do
    alter table(:payment_logs) do
      remove :membership_category_id
      remove :membership_type_id
      add :membership_id, references(:memberships, on_delete: :nothing)      
    end
  end
end
