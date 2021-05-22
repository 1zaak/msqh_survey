defmodule MsqhPortal.Repo.Migrations.ReplaceAnnualPriceAndAddOneTimePriceInDefaultPrices do
  use Ecto.Migration

  def change do
    alter table(:default_prices) do
      remove :annual_price
      add :one_time_annual_price, :integer
      add :renewal_annual_price, :integer      
    end
  end
end
