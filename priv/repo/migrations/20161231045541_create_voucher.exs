defmodule MsqhPortal.Repo.Migrations.CreateVoucher do
  use Ecto.Migration

  def change do
    create table(:vouchers) do
      add :code, :string
      add :discount_percent, :integer
      add :expire_at, :datetime
      add :valid, :boolean, default: false, null: false
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:vouchers, [:code])
    create index(:vouchers, [:event_id])

  end
end
