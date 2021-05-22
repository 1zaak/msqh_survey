defmodule MsqhPortal.Repo.Migrations.AddUniqueFieldsToPackages do
  use Ecto.Migration

  def change do
    create unique_index(:packages, [:facility_id, :membership_category, :membership_type], name: :unique_package)
  end
end
