defmodule MsqhPortal.Repo.Migrations.CreateTablePhoneNumbers do
  use Ecto.Migration

  def change do
    create table(:phone_numbers) do
      add :user_id, references(:users, on_delete: :nothing)
      add :phone_type, :string
      add :phone_number, :string
      
      timestamps()
    end
  end
end
