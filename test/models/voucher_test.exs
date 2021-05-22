defmodule MsqhPortal.VoucherTest do
  use MsqhPortal.ModelCase

  alias MsqhPortal.Voucher

  @valid_attrs %{code: "some content", discount_percent: 42, expire_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, valid: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Voucher.changeset(%Voucher{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Voucher.changeset(%Voucher{}, @invalid_attrs)
    refute changeset.valid?
  end
end
