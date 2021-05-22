defmodule MsqhPortal.Repo.Migrations.ReplaceProfileUpdatedByReferenceToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :profile_updated_by
    end
  end
end
