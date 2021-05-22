defmodule MsqhPortal.Repo.Migrations.RemoveFacilityReferencesToMembershipCategories do
  use Ecto.Migration

  def change do
    alter table(:membership_categories) do
      remove :facility_id
    end
  end
end
