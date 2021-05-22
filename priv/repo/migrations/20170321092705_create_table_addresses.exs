defmodule MsqhPortal.Repo.Migrations.CreateTableAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :user_id, references(:users, on_delete: :nothing)
      add :mailing_address, :string

      timestamps()
    end
    create index(:addresses, [:user_id])
    create index(:phone_numbers, [:user_id])
  end
end
