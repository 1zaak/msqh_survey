defmodule MsqhPortal.Repo.Migrations.AddDefaultDaysBeforeNotifyExpirationInMembershipSetting2 do
  use Ecto.Migration

  def change do
    alter table(:membership_settings) do
      remove :days_before_notify_expiration
      add :days_before_notify_expiration, :integer, default: 10
      remove :inserted_at
      add :inserted_at, :datetime, default: fragment("now()")
      remove :updated_at
      add :updated_at, :datetime, default: fragment("now()")
    end
  end
end
