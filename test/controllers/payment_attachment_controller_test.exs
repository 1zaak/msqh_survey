defmodule MsqhPortal.PaymentAttachmentControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.PaymentAttachment
  @valid_attrs %{file_path: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, payment_attachment_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing payment_attachments"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, payment_attachment_path(conn, :new)
    assert html_response(conn, 200) =~ "New payment attachment"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, payment_attachment_path(conn, :create), payment_attachment: @valid_attrs
    assert redirected_to(conn) == payment_attachment_path(conn, :index)
    assert Repo.get_by(PaymentAttachment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, payment_attachment_path(conn, :create), payment_attachment: @invalid_attrs
    assert html_response(conn, 200) =~ "New payment attachment"
  end

  test "shows chosen resource", %{conn: conn} do
    payment_attachment = Repo.insert! %PaymentAttachment{}
    conn = get conn, payment_attachment_path(conn, :show, payment_attachment)
    assert html_response(conn, 200) =~ "Show payment attachment"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, payment_attachment_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    payment_attachment = Repo.insert! %PaymentAttachment{}
    conn = get conn, payment_attachment_path(conn, :edit, payment_attachment)
    assert html_response(conn, 200) =~ "Edit payment attachment"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    payment_attachment = Repo.insert! %PaymentAttachment{}
    conn = put conn, payment_attachment_path(conn, :update, payment_attachment), payment_attachment: @valid_attrs
    assert redirected_to(conn) == payment_attachment_path(conn, :show, payment_attachment)
    assert Repo.get_by(PaymentAttachment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    payment_attachment = Repo.insert! %PaymentAttachment{}
    conn = put conn, payment_attachment_path(conn, :update, payment_attachment), payment_attachment: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit payment attachment"
  end

  test "deletes chosen resource", %{conn: conn} do
    payment_attachment = Repo.insert! %PaymentAttachment{}
    conn = delete conn, payment_attachment_path(conn, :delete, payment_attachment)
    assert redirected_to(conn) == payment_attachment_path(conn, :index)
    refute Repo.get(PaymentAttachment, payment_attachment.id)
  end
end
