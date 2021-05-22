defmodule MsqhPortal.Repo.Migrations.CreateMembership do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :rate_year, :integer
      add :rate, :integer
      add :period, :string
      add :use_period, :integer

      timestamps()
    end
  end
end
