defmodule MsqhPortal.Repo.Migrations.AddRenewMembershipFieldsToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :membership_type, :string
      add :payment_type, :string
      add :state, :string
      add :proof_payment_path, :string      
    end
  end
end
