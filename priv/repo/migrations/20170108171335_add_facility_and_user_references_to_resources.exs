defmodule MsqhPortal.Repo.Migrations.AddFacilityAndUserReferencesToResources do
  use Ecto.Migration

  def change do
    alter table(:resources) do
      add :facility_id, references(:facilities, on_delete: :nothing)      
    end
  end
end
