defmodule MsqhPortal.FacilityMembershipTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.FacilityMembership

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FacilityMembership.changeset(%FacilityMembership{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FacilityMembership.changeset(%FacilityMembership{}, @invalid_attrs)
    refute changeset.valid?
  end
end
