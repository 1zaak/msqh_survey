defmodule MsqhPortal.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :title, :string
      add :ic, :string
      add :dob, :date
      add :race, :string
      add :gender, :string
      add :nationality, :string
      add :mailing_address, :string
      add :professional_designation, :string
      add :qualification, :string
      add :cv_path, :string
      add :member_certificate_path, :string
    end
  end
end
