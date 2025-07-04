defmodule DemoApp.ShopFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DemoApp.Shop` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: 42
      })
      |> DemoApp.Shop.create_product()

    product
  end
end
