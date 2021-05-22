defmodule MsqhPortal.ResourcePermissionsControllerTest do
  use MsqhPortal.ConnCase

  alias MsqhPortal.ResourcePermissions
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, resource_permissions_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing resource permissions"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, resource_permissions_path(conn, :new)
    assert html_response(conn, 200) =~ "New resource permissions"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, resource_permissions_path(conn, :create), resource_permissions: @valid_attrs
    assert redirected_to(conn) == resource_permissions_path(conn, :index)
    assert Repo.get_by(ResourcePermissions, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, resource_permissions_path(conn, :create), resource_permissions: @invalid_attrs
    assert html_response(conn, 200) =~ "New resource permissions"
  end

  test "shows chosen resource", %{conn: conn} do
    resource_permissions = Repo.insert! %ResourcePermissions{}
    conn = get conn, resource_permissions_path(conn, :show, resource_permissions)
    assert html_response(conn, 200) =~ "Show resource permissions"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, resource_permissions_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    resource_permissions = Repo.insert! %ResourcePermissions{}
    conn = get conn, resource_permissions_path(conn, :edit, resource_permissions)
    assert html_response(conn, 200) =~ "Edit resource permissions"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    resource_permissions = Repo.insert! %ResourcePermissions{}
    conn = put conn, resource_permissions_path(conn, :update, resource_permissions), resource_permissions: @valid_attrs
    assert redirected_to(conn) == resource_permissions_path(conn, :show, resource_permissions)
    assert Repo.get_by(ResourcePermissions, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    resource_permissions = Repo.insert! %ResourcePermissions{}
    conn = put conn, resource_permissions_path(conn, :update, resource_permissions), resource_permissions: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit resource permissions"
  end

  test "deletes chosen resource", %{conn: conn} do
    resource_permissions = Repo.insert! %ResourcePermissions{}
    conn = delete conn, resource_permissions_path(conn, :delete, resource_permissions)
    assert redirected_to(conn) == resource_permissions_path(conn, :index)
    refute Repo.get(ResourcePermissions, resource_permissions.id)
  end
end
