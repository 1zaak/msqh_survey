defmodule MsqhPortal.Repo.Migrations.AddProfileFieldsToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :membership_category, :string
    end
  end
end
