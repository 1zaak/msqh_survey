defmodule MsqhPortal.UserEnquiryControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.UserEnquiry
  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_enquiry_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing user_enquiries"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_enquiry_path(conn, :new)
    assert html_response(conn, 200) =~ "New user enquiry"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_enquiry_path(conn, :create), user_enquiry: @valid_attrs
    assert redirected_to(conn) == user_enquiry_path(conn, :index)
    assert Repo.get_by(UserEnquiry, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_enquiry_path(conn, :create), user_enquiry: @invalid_attrs
    assert html_response(conn, 200) =~ "New user enquiry"
  end

  test "shows chosen resource", %{conn: conn} do
    user_enquiry = Repo.insert! %UserEnquiry{}
    conn = get conn, user_enquiry_path(conn, :show, user_enquiry)
    assert html_response(conn, 200) =~ "Show user enquiry"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_enquiry_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user_enquiry = Repo.insert! %UserEnquiry{}
    conn = get conn, user_enquiry_path(conn, :edit, user_enquiry)
    assert html_response(conn, 200) =~ "Edit user enquiry"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user_enquiry = Repo.insert! %UserEnquiry{}
    conn = put conn, user_enquiry_path(conn, :update, user_enquiry), user_enquiry: @valid_attrs
    assert redirected_to(conn) == user_enquiry_path(conn, :show, user_enquiry)
    assert Repo.get_by(UserEnquiry, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_enquiry = Repo.insert! %UserEnquiry{}
    conn = put conn, user_enquiry_path(conn, :update, user_enquiry), user_enquiry: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user enquiry"
  end

  test "deletes chosen resource", %{conn: conn} do
    user_enquiry = Repo.insert! %UserEnquiry{}
    conn = delete conn, user_enquiry_path(conn, :delete, user_enquiry)
    assert redirected_to(conn) == user_enquiry_path(conn, :index)
    refute Repo.get(UserEnquiry, user_enquiry.id)
  end
end
