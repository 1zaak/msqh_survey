defmodule MsqhPortal.UserPhotoTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.UserPhoto

  @valid_attrs %{file_path: "some content", object: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserPhoto.changeset(%UserPhoto{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserPhoto.changeset(%UserPhoto{}, @invalid_attrs)
    refute changeset.valid?
  end
end
