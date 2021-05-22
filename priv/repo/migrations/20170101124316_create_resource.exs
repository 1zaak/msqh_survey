defmodule MsqhPortal.Repo.Migrations.CreateResource do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :title, :string
      add :description, :string
      add :resource_path, :string

      timestamps()
    end

  end
end
