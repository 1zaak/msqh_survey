defmodule MsqhPortal.PackageDiscount do
  use MsqhPortal.Web, :model

  @doc """
  Lists all discounts for each "package"
  """
  schema "package_discounts" do
    field :discount_percent, :float
    field :original_annual_price, Money.Ecto.Type
    field :discount_annual_price, Money.Ecto.Type
    has_many :package, MsqhPortal.Package

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:discount_percent, :original_annual_price, :discount_annual_price])
    |> validate_required([:discount_percent, :original_annual_price, :discount_annual_price])
  end
end
