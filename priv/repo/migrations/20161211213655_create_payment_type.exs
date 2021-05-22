defmodule MsqhPortal.Repo.Migrations.CreatePaymentType do
  use Ecto.Migration

  def change do
    create table(:payment_types) do
      add :name, :string

      timestamps()
    end

  end
end
