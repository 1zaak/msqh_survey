defmodule MsqhPortal.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :active_from, :datetime
      add :active_to, :datetime
      add :admission_price, :integer
      add :description, :string
      add :location, :string
      add :private, :string

      timestamps()
    end

  end
end
