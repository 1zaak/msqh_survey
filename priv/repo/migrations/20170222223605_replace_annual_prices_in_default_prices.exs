defmodule MsqhPortal.Repo.Migrations.ReplaceAnnualPricesInDefaultPrices do
  use Ecto.Migration

  def change do
    alter table(:default_prices) do
      remove :one_time_annual_price
      remove :renewal_annual_price
      add :life_membership_price, :integer
      add :new_member_annual_price, :integer
      add :renewal_existing_member_annual_price, :integer    
    end
  end
end
