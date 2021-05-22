defmodule MsqhPortal.Repo.Migrations.RenameReferencesInPaymentLogsTable do
  use Ecto.Migration

  def change do
    alter table(:payment_logs) do
      remove :membership_category
      remove :membership_type
      add :membership_category_id, references(:membership_categories, on_delete: :nothing)
      add :membership_type_id, references(:membership_types, on_delete: :nothing)
    end
  end
end
