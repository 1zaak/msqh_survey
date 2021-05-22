defmodule MsqhPortal.Repo.Migrations.CreateResourcePermissions do
  use Ecto.Migration

  def change do
    create table(:resource_permissions) do
      add :resource_id, references(:resources, on_delete: :nothing)
      add :allowed_user_id, references(:users, on_delete: :nothing)
      add :disallowed_user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:resource_permissions, [:resource_id])
    create index(:resource_permissions, [:allowed_user_id])
    create index(:resource_permissions, [:disallowed_user_id])

  end
end
