defmodule MsqhPortal.Repo.Migrations.AddDefaultDaysBeforeNotifyExpirationInMembershipSetting do
  use Ecto.Migration

  def change do
    alter table(:membership_settings) do
      remove :days_before_notify_expiration
      add :days_before_notify_expiration, :integer, default: 10 
    end
  end
end
