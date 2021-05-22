defmodule MsqhPortal.EnquiryResponseControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.EnquiryResponse
  @valid_attrs %{message: "some content", subject: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, enquiry_response_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing enquiry responses"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, enquiry_response_path(conn, :new)
    assert html_response(conn, 200) =~ "New enquiry response"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, enquiry_response_path(conn, :create), enquiry_response: @valid_attrs
    assert redirected_to(conn) == enquiry_response_path(conn, :index)
    assert Repo.get_by(EnquiryResponse, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, enquiry_response_path(conn, :create), enquiry_response: @invalid_attrs
    assert html_response(conn, 200) =~ "New enquiry response"
  end

  test "shows chosen resource", %{conn: conn} do
    enquiry_response = Repo.insert! %EnquiryResponse{}
    conn = get conn, enquiry_response_path(conn, :show, enquiry_response)
    assert html_response(conn, 200) =~ "Show enquiry response"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, enquiry_response_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    enquiry_response = Repo.insert! %EnquiryResponse{}
    conn = get conn, enquiry_response_path(conn, :edit, enquiry_response)
    assert html_response(conn, 200) =~ "Edit enquiry response"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    enquiry_response = Repo.insert! %EnquiryResponse{}
    conn = put conn, enquiry_response_path(conn, :update, enquiry_response), enquiry_response: @valid_attrs
    assert redirected_to(conn) == enquiry_response_path(conn, :show, enquiry_response)
    assert Repo.get_by(EnquiryResponse, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    enquiry_response = Repo.insert! %EnquiryResponse{}
    conn = put conn, enquiry_response_path(conn, :update, enquiry_response), enquiry_response: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit enquiry response"
  end

  test "deletes chosen resource", %{conn: conn} do
    enquiry_response = Repo.insert! %EnquiryResponse{}
    conn = delete conn, enquiry_response_path(conn, :delete, enquiry_response)
    assert redirected_to(conn) == enquiry_response_path(conn, :index)
    refute Repo.get(EnquiryResponse, enquiry_response.id)
  end
end
