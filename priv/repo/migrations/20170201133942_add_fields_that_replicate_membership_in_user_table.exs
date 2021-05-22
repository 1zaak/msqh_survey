defmodule MsqhPortal.Repo.Migrations.AddFieldsThatReplicateMembershipInUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :enquiry_attachment_path, :string
      add :proof_payment_path, :string
      add :receipt_path, :string
      add :payment_verified, :boolean
      add :payment_type_id, references(:payment_types, on_delete: :nothing)
      add :membership_type_id, references(:membership_types, on_delete: :nothing)
      add :membership_category_id, references(:membership_categories, on_delete: :nothing)
      add :package_id, references(:packages, on_delete: :nothing)
      add :package_discount_id, references(:package_discounts, on_delete: :nothing)  
    end
  end
end
