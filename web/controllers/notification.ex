defmodule MsqhPortal.Notification do
  import Plug.Conn
  import Phoenix.Controller
  import Ecto.Query

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def member_unread(conn, repo, user) do
    enquirie_responses = repo.all(from m in MsqhPortal.EnquiryResponse,
    where: m.member_id == ^user.id and m.user_read == false)
    |> Enum.count

    assign(conn, :member_unread, enquirie_responses)
  end

  def admin_unread(conn, repo, _user) do
    enquiries = repo.all(from m in MsqhPortal.Enquiry,
    where: m.admin_replied == false)
    |> Enum.count

    assign(conn, :admin_unread, enquiries)
  end

  def call(conn, repo) do
    unless is_nil(conn.assigns.current_user) do
      if conn.assigns.current_user.state == "ADMIN" or conn.assigns.current_user.state == "SUPERADMIN" do
        admin_unread(conn, repo, conn.assigns.current_user)
      else
        member_unread(conn, repo, conn.assigns.current_user)
      end
    else
      conn
    end
  end
end
