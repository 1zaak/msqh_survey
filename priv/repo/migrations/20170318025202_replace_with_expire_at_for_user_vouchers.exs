defmodule MsqhPortal.Repo.Migrations.ReplaceWithExpireAtForUserVouchers do
  use Ecto.Migration

  def change do
    alter table(:user_vouchers) do
      remove :active_from
      remove :active_to
      add :expire_at, :datetime
    end
  end
end
