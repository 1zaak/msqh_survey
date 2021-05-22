defmodule MsqhPortal.EnquiryControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.Enquiry
  @valid_attrs %{enquiry_attachment_path: "some content", message: "some content", subject: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, enquiry_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing enquiries"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, enquiry_path(conn, :new)
    assert html_response(conn, 200) =~ "New enquiry"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, enquiry_path(conn, :create), enquiry: @valid_attrs
    assert redirected_to(conn) == enquiry_path(conn, :index)
    assert Repo.get_by(Enquiry, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, enquiry_path(conn, :create), enquiry: @invalid_attrs
    assert html_response(conn, 200) =~ "New enquiry"
  end

  test "shows chosen resource", %{conn: conn} do
    enquiry = Repo.insert! %Enquiry{}
    conn = get conn, enquiry_path(conn, :show, enquiry)
    assert html_response(conn, 200) =~ "Show enquiry"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, enquiry_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    enquiry = Repo.insert! %Enquiry{}
    conn = get conn, enquiry_path(conn, :edit, enquiry)
    assert html_response(conn, 200) =~ "Edit enquiry"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    enquiry = Repo.insert! %Enquiry{}
    conn = put conn, enquiry_path(conn, :update, enquiry), enquiry: @valid_attrs
    assert redirected_to(conn) == enquiry_path(conn, :show, enquiry)
    assert Repo.get_by(Enquiry, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    enquiry = Repo.insert! %Enquiry{}
    conn = put conn, enquiry_path(conn, :update, enquiry), enquiry: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit enquiry"
  end

  test "deletes chosen resource", %{conn: conn} do
    enquiry = Repo.insert! %Enquiry{}
    conn = delete conn, enquiry_path(conn, :delete, enquiry)
    assert redirected_to(conn) == enquiry_path(conn, :index)
    refute Repo.get(Enquiry, enquiry.id)
  end
end
