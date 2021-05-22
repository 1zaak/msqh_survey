defmodule MsqhPortal.Repo.Migrations.CreatePackage do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add :facility_name, :string
      add :membership_category, :string
      add :membership_type, :string
      add :annual_price, :integer
      add :facility_id, references(:facilities, on_delete: :nothing)      

      timestamps
    end
  end
end
