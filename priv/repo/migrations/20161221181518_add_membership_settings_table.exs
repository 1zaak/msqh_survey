defmodule MsqhPortal.Repo.Migrations.AddMembershipSettingsTable do
  use Ecto.Migration

  def change do
    create table(:membership_settings) do
      add :days_before_notify_expiration, :integer      

      timestamps()
    end
  end
end
