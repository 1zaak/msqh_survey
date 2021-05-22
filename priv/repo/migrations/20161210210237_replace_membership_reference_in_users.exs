defmodule MsqhPortal.Repo.Migrations.ReplaceMembershipReferenceInUsers do
  use Ecto.Migration

  def change do
    alter table (:users) do
      remove :membership_id
      
    end
  end
end
