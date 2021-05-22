defmodule MsqhPortal.Repo.Migrations.AddReferenceToMemberCertToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :certificate_path, :string
    end

    alter table(:memberships) do
      add :certificate_path, :string
    end
  end
end
