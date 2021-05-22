defmodule ExpireMemberInDbWorker do
  use Toniq.Worker

  alias MsqhPortal.User
  alias MsqhPortal.Email
  alias MsqhPortal.Mailer

  def perform(user) do
    MsqhPortal.ExpirationController.expire(user)
  end
end
