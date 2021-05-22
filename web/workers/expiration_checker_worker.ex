defmodule ExpirationCheckerWorker do
  use Toniq.Worker

  alias MsqhPortal.User
  alias MsqhPortal.Email
  alias MsqhPortal.Mailer

  def perform() do
    MsqhPortal.ExpirationController.check()
  end
end
