defmodule MsqhPortal.Repo.Migrations.CreateMembershipCategory do
  use Ecto.Migration

  def change do
    create table(:membership_categories) do
      add :membership_category_name, :string
      add :facility_id, references(:facilities, on_delete: :nothing)

      timestamps
    end
  end
end
