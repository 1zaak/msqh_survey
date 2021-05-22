defmodule MsqhPortal.PaymentTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.Payment

  @valid_attrs %{amount: "some content", for_period: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Payment.changeset(%Payment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Payment.changeset(%Payment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
