defmodule MsqhPortal.Repo.Migrations.AddMembershipSelectionFieldsToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :active_from, :datetime
      add :active_to, :datetime
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
