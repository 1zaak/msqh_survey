defmodule MsqhPortal.FacilityTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.Facility

  @valid_attrs %{facility_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Facility.changeset(%Facility{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Facility.changeset(%Facility{}, @invalid_attrs)
    refute changeset.valid?
  end
end
