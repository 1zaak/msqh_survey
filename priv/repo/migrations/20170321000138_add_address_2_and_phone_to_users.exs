defmodule MsqhPortal.Repo.Migrations.AddAddress2AndPhoneToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phone, :string
      add :mailing_address_2, :string
    end
  end
end
