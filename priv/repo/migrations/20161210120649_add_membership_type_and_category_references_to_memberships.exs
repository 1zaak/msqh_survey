defmodule MsqhPortal.Repo.Migrations.AddMembershipTypeAndCategoryReferencesToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :membership_type_id, references(:membership_types, on_delete: :nothing)
      add :membership_category_id, references(:membership_categories, on_delete: :nothing)
      remove :membership_type
      remove :membership_category
    end
  end
end
