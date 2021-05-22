defmodule MsqhPortal.Repo.Migrations.CreateCalendar do
  use Ecto.Migration

  def change do
    create table(:calendars) do
      add :cal_name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:calendars, [:user_id])

  end
end
