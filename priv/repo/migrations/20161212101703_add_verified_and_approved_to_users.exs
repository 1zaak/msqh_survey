defmodule MsqhPortal.Repo.Migrations.AddVerifiedAndApprovedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :verified, :boolean
      add :approved, :boolean
    end
  end
end
