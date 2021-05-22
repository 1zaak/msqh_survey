defmodule MsqhPortal.Repo.Migrations.CreatePaymentLogs do
  use Ecto.Migration

  def change do
    create table(:payment_logs) do
      add :paid_when_proof, :integer
      add :paid_when_verified, :integer
      add :facility_id, references(:facilities, on_delete: :nothing)
      add :membership_type_id, references(:membership_types, on_delete: :nothing)
      add :membership_category_id, references(:membership_categories, on_delete: :nothing)
      add :member_id, references(:users, on_delete: :nothing)
      add :admin_id, references(:users, on_delete: :nothing)
      timestamps()
    end
  end
end
