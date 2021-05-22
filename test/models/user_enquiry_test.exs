defmodule MsqhPortal.UserEnquiryTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.UserEnquiry

  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserEnquiry.changeset(%UserEnquiry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserEnquiry.changeset(%UserEnquiry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
