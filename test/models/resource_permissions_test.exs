defmodule MsqhPortal.ResourcePermissionsTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.ResourcePermissions

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ResourcePermissions.changeset(%ResourcePermissions{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ResourcePermissions.changeset(%ResourcePermissions{}, @invalid_attrs)
    refute changeset.valid?
  end
end
