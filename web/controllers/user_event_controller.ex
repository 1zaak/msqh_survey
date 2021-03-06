defmodule MsqhPortal.UserEventController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Event

  def index(conn, params) do
    params_with_page_size = Enum.into(%{"page_size" => 12}, params)
    now = Timex.now()
    events = Event
    |> Event.order_by_active_from
    |> where([e], e.active_from > ^now)
    |> Repo.paginate(params_with_page_size)

    render conn, :index, events: events
  end
end
