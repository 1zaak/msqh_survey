defmodule MsqhPortal.UserPaymentController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.PaymentLog
  @doc """
  Display:
  - Past payments i.e. paid_date, invoice_sent, payment_method, amount, receipt (PAYMENTS table)
  - Membership category (MEMBERSHIP table)
  - Invoice_sent & receipt has PDF (Admin creates file_path first)
  - Upload/edit proof of payment
  """
  def index(conn, params) do
    if conn.assigns.current_user do
      params_with_page_size = Enum.into(%{"page_size" => 5}, params)
      id = conn.assigns.current_user.id      

      payment_history = PaymentLog
      |> where([member_id: ^id])
      |> order_by(desc: :updated_at)
      |> preload([:membership, :membership_category, :membership_type, :package, :package_discount, :facility, :admin, :payment_type])
      |> Repo.paginate(params_with_page_size)

      render conn, "index.html", payment_history: payment_history
    else
      conn
      |> redirect(to: login_path(conn, :index))
    end
  end
end
