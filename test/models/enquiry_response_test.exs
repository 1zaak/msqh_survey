defmodule MsqhPortal.EnquiryResponseTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.EnquiryResponse

  @valid_attrs %{message: "some content", subject: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = EnquiryResponse.changeset(%EnquiryResponse{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = EnquiryResponse.changeset(%EnquiryResponse{}, @invalid_attrs)
    refute changeset.valid?
  end
end
