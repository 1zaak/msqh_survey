defmodule MsqhPortal.CalendarControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.Calendar
  @valid_attrs %{cal_name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, calendar_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing calendars"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, calendar_path(conn, :new)
    assert html_response(conn, 200) =~ "New calendar"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, calendar_path(conn, :create), calendar: @valid_attrs
    assert redirected_to(conn) == calendar_path(conn, :index)
    assert Repo.get_by(Calendar, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, calendar_path(conn, :create), calendar: @invalid_attrs
    assert html_response(conn, 200) =~ "New calendar"
  end

  test "shows chosen resource", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = get conn, calendar_path(conn, :show, calendar)
    assert html_response(conn, 200) =~ "Show calendar"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, calendar_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = get conn, calendar_path(conn, :edit, calendar)
    assert html_response(conn, 200) =~ "Edit calendar"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = put conn, calendar_path(conn, :update, calendar), calendar: @valid_attrs
    assert redirected_to(conn) == calendar_path(conn, :show, calendar)
    assert Repo.get_by(Calendar, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = put conn, calendar_path(conn, :update, calendar), calendar: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit calendar"
  end

  test "deletes chosen resource", %{conn: conn} do
    calendar = Repo.insert! %Calendar{}
    conn = delete conn, calendar_path(conn, :delete, calendar)
    assert redirected_to(conn) == calendar_path(conn, :index)
    refute Repo.get(Calendar, calendar.id)
  end
end
