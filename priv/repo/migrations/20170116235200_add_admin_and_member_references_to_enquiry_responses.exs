defmodule MsqhPortal.Repo.Migrations.AddAdminAndMemberReferencesToEnquiryResponses do
  use Ecto.Migration

  def change do
    alter table(:enquiry_responses) do
      remove :read
      remove :replied
      add :user_read, :boolean
      add :user_replied, :boolean
      add :admin_read, :boolean
      add :admin_replied, :boolean
      add :member_id, references(:users, on_delete: :nothing)
      add :admin_id, references(:users, on_delete: :nothing)
    end

    alter table(:enquiries) do
      remove :read
      remove :replied
      add :user_read, :boolean
      add :user_replied, :boolean
      add :admin_read, :boolean
      add :admin_replied, :boolean      
    end
  end
end
