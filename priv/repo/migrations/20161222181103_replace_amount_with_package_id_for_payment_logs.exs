defmodule MsqhPortal.Repo.Migrations.ReplaceAmountWithPackageIdForPaymentLogs do
  use Ecto.Migration

  def change do
    alter table(:payment_logs) do
      remove :amount_when_proving
      remove :amount_when_verifying
      add :package_id, references(:packages, on_delete: :nothing)
      add :package_discount_id, references(:package_discounts, on_delete: :nothing)
      add :rate_year, :integer
      add :rate, :integer
      add :period, :string
      add :use_period, :integer
      add :payment_type, :string
      add :state, :string
      add :proof_payment_path, :string
      add :active_from, :datetime
      add :active_to, :datetime
      add :payment_verified, :boolean
      add :membership_type, references(:membership_types, on_delete: :nothing)
      add :membership_category, references(:membership_categories, on_delete: :nothing)
    end
  end
end
