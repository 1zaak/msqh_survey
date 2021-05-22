defmodule MsqhPortal.EnquiryTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.Enquiry

  @valid_attrs %{enquiry_attachment_path: "some content", message: "some content", subject: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Enquiry.changeset(%Enquiry{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Enquiry.changeset(%Enquiry{}, @invalid_attrs)
    refute changeset.valid?
  end
end
