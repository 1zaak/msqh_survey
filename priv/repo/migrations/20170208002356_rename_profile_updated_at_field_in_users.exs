defmodule MsqhPortal.Repo.Migrations.RenameProfileUpdatedAtFieldInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :profile_update_at
      add :profile_updated_at, :datetime
    end
  end
end
