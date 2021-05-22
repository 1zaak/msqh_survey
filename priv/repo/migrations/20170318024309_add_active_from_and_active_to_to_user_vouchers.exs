defmodule MsqhPortal.Repo.Migrations.AddActiveFromAndActiveToToUserVouchers do
  use Ecto.Migration

  def change do
    alter table(:user_vouchers) do
      add :active_from, :datetime
      add :active_to, :datetime
    end
  end
end
