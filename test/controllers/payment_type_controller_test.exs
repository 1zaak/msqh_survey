defmodule MsqhPortal.PaymentTypeControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.PaymentType
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, payment_type_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing payment types"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, payment_type_path(conn, :new)
    assert html_response(conn, 200) =~ "New payment type"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, payment_type_path(conn, :create), payment_type: @valid_attrs
    assert redirected_to(conn) == payment_type_path(conn, :index)
    assert Repo.get_by(PaymentType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, payment_type_path(conn, :create), payment_type: @invalid_attrs
    assert html_response(conn, 200) =~ "New payment type"
  end

  test "shows chosen resource", %{conn: conn} do
    payment_type = Repo.insert! %PaymentType{}
    conn = get conn, payment_type_path(conn, :show, payment_type)
    assert html_response(conn, 200) =~ "Show payment type"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, payment_type_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    payment_type = Repo.insert! %PaymentType{}
    conn = get conn, payment_type_path(conn, :edit, payment_type)
    assert html_response(conn, 200) =~ "Edit payment type"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    payment_type = Repo.insert! %PaymentType{}
    conn = put conn, payment_type_path(conn, :update, payment_type), payment_type: @valid_attrs
    assert redirected_to(conn) == payment_type_path(conn, :show, payment_type)
    assert Repo.get_by(PaymentType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    payment_type = Repo.insert! %PaymentType{}
    conn = put conn, payment_type_path(conn, :update, payment_type), payment_type: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit payment type"
  end

  test "deletes chosen resource", %{conn: conn} do
    payment_type = Repo.insert! %PaymentType{}
    conn = delete conn, payment_type_path(conn, :delete, payment_type)
    assert redirected_to(conn) == payment_type_path(conn, :index)
    refute Repo.get(PaymentType, payment_type.id)
  end
end
