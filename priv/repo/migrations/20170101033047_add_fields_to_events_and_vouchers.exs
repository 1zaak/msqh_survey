defmodule MsqhPortal.Repo.Migrations.AddFieldsToEventsAndVouchers do
  use Ecto.Migration

  def change do
    alter table(:vouchers) do
      remove :discount_percent
      add :discount_percent, :float
    end
  end
end
