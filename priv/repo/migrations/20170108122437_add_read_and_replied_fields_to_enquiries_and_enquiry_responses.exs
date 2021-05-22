defmodule MsqhPortal.Repo.Migrations.AddReadAndRepliedFieldsToEnquiriesAndEnquiryResponses do
  use Ecto.Migration

  def change do
    alter table(:enquiries) do
      add :read, :boolean
      add :replied, :boolean
    end

    alter table(:enquiry_responses) do
      add :read, :boolean
      add :replied, :boolean
    end
  end
end
