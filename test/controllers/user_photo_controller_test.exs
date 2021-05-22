defmodule MsqhPortal.UserPhotoControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.UserPhoto
  @valid_attrs %{file_path: "some content", object: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_photo_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing user_photos"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_photo_path(conn, :new)
    assert html_response(conn, 200) =~ "New user photo"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_photo_path(conn, :create), user_photo: @valid_attrs
    assert redirected_to(conn) == user_photo_path(conn, :index)
    assert Repo.get_by(UserPhoto, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_photo_path(conn, :create), user_photo: @invalid_attrs
    assert html_response(conn, 200) =~ "New user photo"
  end

  test "shows chosen resource", %{conn: conn} do
    user_photo = Repo.insert! %UserPhoto{}
    conn = get conn, user_photo_path(conn, :show, user_photo)
    assert html_response(conn, 200) =~ "Show user photo"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_photo_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user_photo = Repo.insert! %UserPhoto{}
    conn = get conn, user_photo_path(conn, :edit, user_photo)
    assert html_response(conn, 200) =~ "Edit user photo"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user_photo = Repo.insert! %UserPhoto{}
    conn = put conn, user_photo_path(conn, :update, user_photo), user_photo: @valid_attrs
    assert redirected_to(conn) == user_photo_path(conn, :show, user_photo)
    assert Repo.get_by(UserPhoto, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_photo = Repo.insert! %UserPhoto{}
    conn = put conn, user_photo_path(conn, :update, user_photo), user_photo: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user photo"
  end

  test "deletes chosen resource", %{conn: conn} do
    user_photo = Repo.insert! %UserPhoto{}
    conn = delete conn, user_photo_path(conn, :delete, user_photo)
    assert redirected_to(conn) == user_photo_path(conn, :index)
    refute Repo.get(UserPhoto, user_photo.id)
  end
end
