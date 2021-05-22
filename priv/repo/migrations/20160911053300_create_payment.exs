defmodule MsqhPortal.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount, :string
      add :for_period, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:payments, [:user_id])

  end
end
