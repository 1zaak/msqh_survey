defmodule MsqhPortal.UserEnquiryAttachmentTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.UserEnquiryAttachment

  @valid_attrs %{file_path: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserEnquiryAttachment.changeset(%UserEnquiryAttachment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserEnquiryAttachment.changeset(%UserEnquiryAttachment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
