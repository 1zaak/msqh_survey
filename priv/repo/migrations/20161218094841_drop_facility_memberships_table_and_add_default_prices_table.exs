defmodule MsqhPortal.Repo.Migrations.DropFacilityMembershipsTableAndAddDefaultPricesTable do
  use Ecto.Migration

  def change do    
    create table(:default_prices) do
      add :membership_type_id, references(:membership_types, on_delete: :nothing)
      add :membership_category_id, references(:membership_categories, on_delete: :nothing)
      add :annual_price, :integer
      timestamps()
    end
  end
end
