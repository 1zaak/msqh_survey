defmodule MsqhPortal.Repo.Migrations.CreatePackageDiscount do
  use Ecto.Migration

  def change do
    create table(:package_discounts) do
      add :discount_percent, :float
      add :original_annual_price, :integer
      add :discount_annual_price, :integer

      timestamps
    end
  end
end
