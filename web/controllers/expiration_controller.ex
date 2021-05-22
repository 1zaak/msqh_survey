defmodule MsqhPortal.ExpirationController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.User
  alias MsqhPortal.MembershipSetting

  def check() do
    members = Repo.all from user in User,
    where: user.state == "ACTIVE" or user.state == "PAID"
    limit = Repo.get MembershipSetting, 1

    for member <- members do
      remaining_day = member.active_to
      |> Calendar.Date.diff(Calendar.DateTime.now_utc)

      if remaining_day <= limit.days_before_notify_expiration do
        ExpireMemberInDbWorker.perform(member)
      end

    end
  end

  def expire(user) do
    changeset = User.expire_changeset(user)

    case Repo.update(changeset) do
      {:ok, user} ->
        # To send email to admin list of expired users (1 email only)
        IO.inspect user.username <> " expired successfully."
      {:error, changeset} ->
        IO.inspect changeset
    end
  end
end
