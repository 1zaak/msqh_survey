defmodule MsqhPortal.Repo.Migrations.AddDefaultPricesToPackages do
  use Ecto.Migration

  def change do
    alter table(:packages) do
      remove :annual_price      
      add :life_membership_price, :integer
      add :new_member_annual_price, :integer
      add :renewal_existing_member_annual_price, :integer
    end
  end
end
