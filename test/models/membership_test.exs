defmodule MsqhPortal.MembershipTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.Membership

  @valid_attrs %{period: "some content", rate: 42, rate_year: 42, use_period: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Membership.changeset(%Membership{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Membership.changeset(%Membership{}, @invalid_attrs)
    refute changeset.valid?
  end
end
