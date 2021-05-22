defmodule MsqhPortal.Repo.Migrations.CreateMembershipType do
  use Ecto.Migration

  def change do
    create table(:membership_types) do
      add :membership_type_name, :string
      add :facility_id, references(:facilities, on_delete: :nothing)

      timestamps
    end
  end
end
