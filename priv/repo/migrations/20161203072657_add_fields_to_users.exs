defmodule MsqhPortal.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :active_from, :datetime
      add :active_to, :datetime
      add :current_paid, :integer
    end
  end
end
