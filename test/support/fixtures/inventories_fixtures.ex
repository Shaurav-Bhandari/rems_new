defmodule BinduBackend.InventoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Inventories` context.
  """

  @doc """
  Generate a inventory.
  """
  def inventory_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        category: "some category",
        current_quantity: 120.5,
        description: "some description",
        last_restock_date: ~D[2026-05-09],
        maximum_quantity: 120.5,
        measurement_unit: "some measurement_unit",
        minimum_quantity: 120.5,
        name: "some name",
        reorder_point: 120.5,
        sku: "some sku",
        unit_cost: 120.5
      })

    {:ok, inventory} = BinduBackend.Inventories.create_inventory(scope, attrs)
    inventory
  end
end
