defmodule MsqhPortal.Repo.Migrations.ReplacePaymentTypeInMembershipsWithReferences do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      remove :payment_type
      add :payment_type_id, references(:payment_types, on_delete: :nothing)
    end

    alter table(:payment_logs) do
      remove :payment_type
      add :payment_type_id, references(:payment_types, on_delete: :nothing)
    end
  end
end
