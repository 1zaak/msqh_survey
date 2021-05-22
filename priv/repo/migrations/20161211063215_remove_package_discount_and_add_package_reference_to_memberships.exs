defmodule MsqhPortal.Repo.Migrations.RemovePackageDiscountAndAddPackageReferenceToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      remove :package_discount_id
      add :package__id, references(:packages, on_delete: :nothing)
    end
  end
end
