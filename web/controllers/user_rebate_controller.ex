defmodule MsqhPortal.UserRebateController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.UserVoucher
  alias MsqhPortal.User

  def index(conn, params) do
    params_with_page_size = Enum.into(%{"page_size" => 12}, params)
    user = Repo.get!(User, conn.assigns.current_user.id)
    now = Timex.now()

    # user_vouchers = Repo.all(from v in UserVoucher,
    # where: v.user_id == ^user.id and v.expire_at > ^now,
    # order_by: [desc: v.updated_at],
    # preload: [{:voucher, [:event]}])
    # |> Repo.paginate(params_with_page_size)

    user_vouchers = UserVoucher
    |> where([user_id: ^user.id])
    |> where([e], e.expire_at > ^now)
    |> order_by(desc: :updated_at)
    |> preload([{:voucher, [:event]}])
    |> Repo.paginate(params_with_page_size)

    render conn, :index, user_vouchers: user_vouchers
  end
end
