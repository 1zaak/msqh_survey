defmodule MsqhPortal.Repo.Migrations.AddProfileUpdatedByReferenceToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_updated_by, references(:users, on_delete: :nothing)
    end
  end
end
