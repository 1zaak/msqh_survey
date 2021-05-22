defmodule MsqhPortal.Repo.Migrations.AddFacilityReferenceToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :facility_id, references(:facilities, on_delete: :nothing)
    end
  end
end
