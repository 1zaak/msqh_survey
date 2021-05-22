defmodule MsqhPortal.Repo.Migrations.AddPaymentVerifiedToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :payment_verified, :boolean      
    end
  end
end
