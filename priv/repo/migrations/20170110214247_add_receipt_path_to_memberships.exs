defmodule MsqhPortal.Repo.Migrations.AddReceiptPathToMemberships do
  use Ecto.Migration

  def change do
    alter table(:memberships) do
      add :receipt_path, :string
    end
  end
end
