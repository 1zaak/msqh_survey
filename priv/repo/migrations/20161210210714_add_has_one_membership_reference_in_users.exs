defmodule MsqhPortal.Repo.Migrations.AddHasOneMembershipReferenceInUsers do
  use Ecto.Migration

  def change do
    alter table (:users) do
      add :membership_id, references(:memberships, on_delete: :nothing)    
    end
  end
end
