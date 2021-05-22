defmodule MsqhPortal.Repo.Migrations.AddFieldsToEnquiries do
  use Ecto.Migration

  def change do
    alter table(:enquiries) do
      add :member_id, references(:users, on_delete: :nothing)
    end
    create index(:enquiries, [:member_id])
  end
end
