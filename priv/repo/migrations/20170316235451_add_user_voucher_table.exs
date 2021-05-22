defmodule MsqhPortal.Repo.Migrations.AddUserVoucherTable do
  use Ecto.Migration

  def change do
    create table(:user_vouchers) do
      add :user_id, references(:users, on_delete: :nothing)
      add :voucher_id, references(:vouchers, on_delete: :nothing)

      timestamps()
    end

    create index(:user_vouchers, [:user_id])
    create index(:user_vouchers, [:voucher_id])
  end
end
