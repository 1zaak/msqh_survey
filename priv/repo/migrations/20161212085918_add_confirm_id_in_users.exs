defmodule MsqhPortal.Repo.Migrations.AddConfirmIdInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirm_id, :string
    end
  end
end
