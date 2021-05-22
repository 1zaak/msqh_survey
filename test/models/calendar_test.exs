defmodule MsqhPortal.CalendarTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.Calendar

  @valid_attrs %{cal_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Calendar.changeset(%Calendar{}, @invalid_attrs)
    refute changeset.valid?
  end
end
