defmodule MsqhPortal.Repo.Migrations.AddAnnualPriceToFacilityMemberships do
  use Ecto.Migration

  def change do
    alter table(:facility_memberships) do
      add :annual_price, :integer      
    end
  end
end
