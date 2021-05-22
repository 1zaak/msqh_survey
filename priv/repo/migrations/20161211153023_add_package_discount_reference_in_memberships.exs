defmodule MsqhPortal.Repo.Migrations.AddPackageDiscountReferenceInMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :package_discount_id, references(:package_discounts, on_delete: :nothing)
    end
  end
end
