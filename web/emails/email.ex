defmodule MsqhPortal.Email do
  import Bamboo.Email
  alias MsqhPortal.Router.Helpers

  @doc """

  Pipe using Bamboo.Email functions
  new_email
  |> to("foo@example.com")
  |> from("me@example.com")
  |> subject("Welcome!!!")
  |> html_body("<strong>Welcome</strong>")
  |> text_body("welcome")

  """
  def verify_email(email, confirm_id) do
    new_email(
      to: email,
      from: "membership@msqh.com.my",
      subject: "MSQH member account verification",
      html_body: "<strong>Thanks for joining! Verify your account <a href='" <> Helpers.activation_url(MsqhPortal.Endpoint, :confirm, confirm_id) <>"'>here.</a></strong>",
      text_body: "Thanks for joining!"
    )
  end

  def near_expiration_email(email, _user) do
    new_email(
      to: email,
      from: "membership@msqh.com.my",
      subject: "Your MSQH membership is expiring",
      html_body: "<p>Hi! You are nearing the end of your membership period. We would love for you to still be our MSQH member. Please renew your account here.",
      text_body: "Thanks for being a part of us!"
    )
  end

  def change_password_email(email, user) do
    new_email(
      to: email,
      from: "membership@msqh.com.my",
      subject: "MSQH reset password",
      html_body: "<strong>Reset your password <a href='" <> Helpers.login_url(MsqhPortal.Endpoint, :reset, user) <>"'>here.</a></strong>"
    )
  end

end
