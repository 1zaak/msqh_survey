defmodule MsqhPortal.VoucherController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Voucher
  alias MsqhPortal.Event

  plug :load_events when action in [:new]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params])
  end

  def index(conn, _params) do
    vouchers = Repo.all(Voucher)
    render(conn, "index.html", vouchers: vouchers)
  end

  def new(conn, _params) do
    changeset = Voucher.changeset(%Voucher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"voucher" => voucher_params}) do
    IO.inspect voucher_params
    event = Repo.get!(Event, voucher_params["event_id"])
    voucher_params_with_random_code = Enum.into(%{
      "code" => :crypto.strong_rand_bytes(6)
      |> Base.url_encode64
      |> binary_part(0, 6)
    }, voucher_params)

    changeset = Voucher.changeset(%Voucher{}, voucher_params_with_random_code)

    case Repo.insert(changeset) do
      {:ok, _voucher} ->
        conn
        |> put_flash(:info, "Voucher created successfully.")
        |> redirect(to: admin_event_path(conn, :show, event: event))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Problem creating voucher.")
        |> redirect(to: admin_event_path(conn, :show, event: event, changeset: changeset))
    end
  end

  def show(conn, %{"id" => id}) do
    voucher = Repo.get!(Voucher, id)
    render(conn, "show.html", voucher: voucher)
  end

  def edit(conn, %{"id" => id}) do
    voucher = Repo.get!(Voucher, id)
    changeset = Voucher.changeset(voucher)
    render(conn, "edit.html", voucher: voucher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "voucher" => voucher_params}) do
    voucher = Repo.get!(Voucher, id)
    changeset = Voucher.changeset(voucher, voucher_params)

    case Repo.update(changeset) do
      {:ok, voucher} ->
        conn
        |> put_flash(:info, "Voucher updated successfully.")
        |> redirect(to: voucher_path(conn, :show, voucher))
      {:error, changeset} ->
        render(conn, "edit.html", voucher: voucher, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    voucher = Repo.get!(Voucher, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(voucher)

    conn
    |> put_flash(:info, "Voucher deleted successfully.")
    |> redirect(to: voucher_path(conn, :index))
  end

  defp load_events(conn, _) do
    query =
    Event
    events = Repo.all query
    assign(conn, :events, events)
  end
end
