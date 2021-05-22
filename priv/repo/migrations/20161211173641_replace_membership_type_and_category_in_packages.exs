defmodule MsqhPortal.Repo.Migrations.ReplaceMembershipTypeAndCategoryInPackages do
  use Ecto.Migration

  def change do
    alter table(:packages) do
      remove :membership_type
      remove :membership_category
      add :membership_type_id, references(:membership_types, on_delete: :nothing)
      add :membership_category_id, references(:membership_categories, on_delete: :nothing)
    end
  end
end
