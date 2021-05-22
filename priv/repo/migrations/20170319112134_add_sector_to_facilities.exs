defmodule MsqhPortal.Repo.Migrations.AddSectorToFacilities do
  use Ecto.Migration

  def change do
    alter table(:facilities) do
      add :sector, :string
    end
  end
end
