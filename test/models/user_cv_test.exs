defmodule MsqhPortal.UserCvTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.UserCv

  @valid_attrs %{file_path: "some content", object: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserCv.changeset(%UserCv{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserCv.changeset(%UserCv{}, @invalid_attrs)
    refute changeset.valid?
  end
end
