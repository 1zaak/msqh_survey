defmodule MsqhPortal.Repo.Migrations.RemoveFacilityReferencesToMembershipTypes do
  use Ecto.Migration

  def change do
    alter table(:membership_types) do
      remove :facility_id
    end
  end
end
