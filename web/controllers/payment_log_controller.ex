defmodule MsqhPortal.PaymentLogController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.PaymentLog

  @doc """
  Logs all payments:
  1) When user uploads Proof of Payment
  2) When admin verify user's payment
  """

  def index(conn, params) do
    unless is_nil(conn.assigns.current_user) do
      if conn.assigns.current_user.state === "ADMIN" || conn.assigns.current_user.state === "SUPERADMIN" do
        params_with_page_size = Enum.into(%{"page_size" => 12}, params)

        payment_logs = PaymentLog
        |> order_by(desc: :updated_at)
        |> preload([:membership_type, :membership_category, :package, :member, :admin, :facility, :membership, :payment_type])
        |> Repo.paginate(params_with_page_size)
        IO.inspect payment_logs
        render conn, :index, payment_logs: payment_logs
      else
        conn
        |> put_flash(:error, "Only admin can access this page.")
        |> redirect(to: login_path(conn, :index))
      end
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end
  end

end
