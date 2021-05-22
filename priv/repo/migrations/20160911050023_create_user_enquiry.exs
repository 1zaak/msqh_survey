defmodule MsqhPortal.Repo.Migrations.CreateUserEnquiry do
  use Ecto.Migration

  def change do
    create table(:user_enquiries) do
      add :title, :string
      add :content, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:user_enquiries, [:user_id])

  end
end
