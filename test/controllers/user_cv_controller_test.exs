defmodule MsqhPortal.UserCvControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.UserCv
  @valid_attrs %{file_path: "some content", object: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_cv_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing user_cvs"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_cv_path(conn, :new)
    assert html_response(conn, 200) =~ "New user cv"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_cv_path(conn, :create), user_cv: @valid_attrs
    assert redirected_to(conn) == user_cv_path(conn, :index)
    assert Repo.get_by(UserCv, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_cv_path(conn, :create), user_cv: @invalid_attrs
    assert html_response(conn, 200) =~ "New user cv"
  end

  test "shows chosen resource", %{conn: conn} do
    user_cv = Repo.insert! %UserCv{}
    conn = get conn, user_cv_path(conn, :show, user_cv)
    assert html_response(conn, 200) =~ "Show user cv"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_cv_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user_cv = Repo.insert! %UserCv{}
    conn = get conn, user_cv_path(conn, :edit, user_cv)
    assert html_response(conn, 200) =~ "Edit user cv"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user_cv = Repo.insert! %UserCv{}
    conn = put conn, user_cv_path(conn, :update, user_cv), user_cv: @valid_attrs
    assert redirected_to(conn) == user_cv_path(conn, :show, user_cv)
    assert Repo.get_by(UserCv, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_cv = Repo.insert! %UserCv{}
    conn = put conn, user_cv_path(conn, :update, user_cv), user_cv: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user cv"
  end

  test "deletes chosen resource", %{conn: conn} do
    user_cv = Repo.insert! %UserCv{}
    conn = delete conn, user_cv_path(conn, :delete, user_cv)
    assert redirected_to(conn) == user_cv_path(conn, :index)
    refute Repo.get(UserCv, user_cv.id)
  end
end
