defmodule SendEmailWorker do
  use Toniq.Worker
  alias MsqhPortal.Email
  alias MsqhPortal.Mailer

  def perform() do    
    Email.near_expiration_email("izaak@izaak.my", "izaak") |> Mailer.deliver_later
  end
end
