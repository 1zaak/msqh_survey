defmodule MsqhPortal.UserEnquiryAttachmentControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.UserEnquiryAttachment
  @valid_attrs %{file_path: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_enquiry_attachment_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing user_enquiry_attachments"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_enquiry_attachment_path(conn, :new)
    assert html_response(conn, 200) =~ "New user enquiry attachment"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_enquiry_attachment_path(conn, :create), user_enquiry_attachment: @valid_attrs
    assert redirected_to(conn) == user_enquiry_attachment_path(conn, :index)
    assert Repo.get_by(UserEnquiryAttachment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_enquiry_attachment_path(conn, :create), user_enquiry_attachment: @invalid_attrs
    assert html_response(conn, 200) =~ "New user enquiry attachment"
  end

  test "shows chosen resource", %{conn: conn} do
    user_enquiry_attachment = Repo.insert! %UserEnquiryAttachment{}
    conn = get conn, user_enquiry_attachment_path(conn, :show, user_enquiry_attachment)
    assert html_response(conn, 200) =~ "Show user enquiry attachment"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_enquiry_attachment_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user_enquiry_attachment = Repo.insert! %UserEnquiryAttachment{}
    conn = get conn, user_enquiry_attachment_path(conn, :edit, user_enquiry_attachment)
    assert html_response(conn, 200) =~ "Edit user enquiry attachment"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user_enquiry_attachment = Repo.insert! %UserEnquiryAttachment{}
    conn = put conn, user_enquiry_attachment_path(conn, :update, user_enquiry_attachment), user_enquiry_attachment: @valid_attrs
    assert redirected_to(conn) == user_enquiry_attachment_path(conn, :show, user_enquiry_attachment)
    assert Repo.get_by(UserEnquiryAttachment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_enquiry_attachment = Repo.insert! %UserEnquiryAttachment{}
    conn = put conn, user_enquiry_attachment_path(conn, :update, user_enquiry_attachment), user_enquiry_attachment: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user enquiry attachment"
  end

  test "deletes chosen resource", %{conn: conn} do
    user_enquiry_attachment = Repo.insert! %UserEnquiryAttachment{}
    conn = delete conn, user_enquiry_attachment_path(conn, :delete, user_enquiry_attachment)
    assert redirected_to(conn) == user_enquiry_attachment_path(conn, :index)
    refute Repo.get(UserEnquiryAttachment, user_enquiry_attachment.id)
  end
end
