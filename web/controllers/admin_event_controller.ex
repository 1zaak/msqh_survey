defmodule MsqhPortal.AdminEventController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Event
  alias MsqhPortal.Voucher
  alias MsqhPortal.User
  alias MsqhPortal.UserVoucher
  alias Ecto.Multi

  def index(conn, params) do
    params_with_page_size = Enum.into(%{"page_size" => 12}, params)

    events = Event
    |> Event.order_by_active_from
    |> preload([:vouchers])
    |> Repo.paginate(params_with_page_size)

    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Event.changeset(%Event{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    changeset = Event.changeset(%Event{}, event_params)

    case Repo.insert(changeset) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: admin_event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    |> Repo.preload([:vouchers])

    users = Repo.all(from m in User,
    where: m.state != "ADMIN" and m.state != "SUPERADMIN",
    order_by: [desc: m.username])
    |> Enum.map(fn(user) ->
      {user.username, user.id}
    end)

    changeset = Voucher.changeset(%Voucher{expire_at: Timex.Timezone.convert(event.active_to, "Asia/Kuala_Lumpur")})

    render(conn, "show.html", event: event, changeset: changeset, vouchers: event.vouchers, users: users)
  end

  def voucher_create(conn, %{"voucher" => voucher_params}) do
    now = Timex.Timezone.convert(Timex.now, "Asia/Kuala_Lumpur")
    voucher_params_with_random_code = Enum.into(%{
      "code" => :crypto.strong_rand_bytes(6)
      |> Base.url_encode64
      |> binary_part(0, 6)
    }, voucher_params)

    changeset = Voucher.changeset(%Voucher{}, voucher_params_with_random_code)

    transaction = Multi.new
    |> Multi.insert(:voucher, changeset)
    |> Multi.run(:uservouchers, fn %{voucher: voucher} ->
      user_vouchers_to_insert = for user_id <- voucher_params["user_ids"] do
        %{voucher_id: voucher.id, user_id: String.to_integer(user_id), inserted_at: now, updated_at: now, expire_at: voucher.expire_at}
      end

      count = Enum.count(voucher_params["user_ids"])
      case Repo.insert_all(UserVoucher, user_vouchers_to_insert) do
        {x, user_vouchers} when x == count ->
          {:ok, user_vouchers}
        {x, user_vouchers} when x != count ->
          {:error, user_vouchers}
      end
    end)

    case Repo.transaction(transaction) do
      {:ok, _result} ->
        event = Repo.get!(Event, voucher_params_with_random_code["event_id"])
        |> Repo.preload([:vouchers])

        users = Repo.all(from m in User,
        where: m.state != "ADMIN" and m.state != "SUPERADMIN",
        order_by: [desc: m.username])
        |> Enum.map(fn(user) ->
          {user.username, user.id}
        end)

        changeset = Voucher.changeset(%Voucher{expire_at: Timex.Timezone.convert(event.active_to, "Asia/Kuala_Lumpur")})

        conn
        |> put_flash(:info, "Vouchers created successfully.")
        render(conn, "show.html", event: event, changeset: changeset, vouchers: event.vouchers, users: users)
      {:error, _result} ->
        conn
        |> put_flash(:error, "Vouchers fail to be created successfully.")
        |> redirect(to: admin_event_path(conn, :new))
    end
  end

  def edit(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)
    changeset = Event.changeset(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Repo.get!(Event, id)
    changeset = Event.changeset(event, event_params)

    case Repo.update(changeset) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: admin_event_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Repo.get!(Event, id)

    Repo.delete!(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: admin_event_path(conn, :index))
  end
end
