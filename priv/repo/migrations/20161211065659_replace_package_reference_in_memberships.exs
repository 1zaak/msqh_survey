defmodule MsqhPortal.Repo.Migrations.ReplacePackageReferenceInMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      remove :package__id
      add :package_id, references(:packages, on_delete: :nothing)
    end
  end
end
