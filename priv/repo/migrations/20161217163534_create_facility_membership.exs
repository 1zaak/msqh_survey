defmodule MsqhPortal.Repo.Migrations.CreateFacilityMembership do
  use Ecto.Migration

  def change do
    create table(:facility_memberships) do
      add :facility_id, references(:facilities, on_delete: :nothing)
      add :membership_type_id, references(:membership_types, on_delete: :nothing)
      add :membership_category_id, references(:membership_categories, on_delete: :nothing)
      timestamps()
    end

    alter table(:facilities) do
      remove :membership_id
      add :facility_membership_id, references(:facility_memberships, on_delete: :nothing)
    end
  end
end
