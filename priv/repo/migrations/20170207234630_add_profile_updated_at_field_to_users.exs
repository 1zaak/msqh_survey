defmodule MsqhPortal.Repo.Migrations.AddProfileUpdatedAtFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_update_at, :datetime      
    end
  end
end
