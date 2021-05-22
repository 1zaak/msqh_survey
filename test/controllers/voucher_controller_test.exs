defmodule MsqhPortal.VoucherControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.Voucher
  @valid_attrs %{code: "some content", discount_percent: 42, expire_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, valid: true}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, voucher_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing vouchers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, voucher_path(conn, :new)
    assert html_response(conn, 200) =~ "New voucher"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, voucher_path(conn, :create), voucher: @valid_attrs
    assert redirected_to(conn) == voucher_path(conn, :index)
    assert Repo.get_by(Voucher, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, voucher_path(conn, :create), voucher: @invalid_attrs
    assert html_response(conn, 200) =~ "New voucher"
  end

  test "shows chosen resource", %{conn: conn} do
    voucher = Repo.insert! %Voucher{}
    conn = get conn, voucher_path(conn, :show, voucher)
    assert html_response(conn, 200) =~ "Show voucher"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, voucher_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    voucher = Repo.insert! %Voucher{}
    conn = get conn, voucher_path(conn, :edit, voucher)
    assert html_response(conn, 200) =~ "Edit voucher"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    voucher = Repo.insert! %Voucher{}
    conn = put conn, voucher_path(conn, :update, voucher), voucher: @valid_attrs
    assert redirected_to(conn) == voucher_path(conn, :show, voucher)
    assert Repo.get_by(Voucher, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    voucher = Repo.insert! %Voucher{}
    conn = put conn, voucher_path(conn, :update, voucher), voucher: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit voucher"
  end

  test "deletes chosen resource", %{conn: conn} do
    voucher = Repo.insert! %Voucher{}
    conn = delete conn, voucher_path(conn, :delete, voucher)
    assert redirected_to(conn) == voucher_path(conn, :index)
    refute Repo.get(Voucher, voucher.id)
  end
end
