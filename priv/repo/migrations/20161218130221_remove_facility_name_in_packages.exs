defmodule MsqhPortal.Repo.Migrations.RemoveFacilityNameInPackages do
  use Ecto.Migration

  def change do
    alter table(:packages) do
      remove :facility_name
    end
  end
end
