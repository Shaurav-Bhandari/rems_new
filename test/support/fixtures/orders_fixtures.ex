defmodule BinduBackend.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        notes: "some notes",
        order_status: "some order_status",
        order_type: "some order_type",
        service_charge: 120.5,
        sub_total: 120.5,
        taken_by_id: "7488a646-e31f-11e4-aace-600308960662",
        total_amount: 120.5
      })
      |> BinduBackend.Orders.create_order()

    order
  end

  @doc """
  Generate a order_group.
  """
  def order_group_fixture(attrs \\ %{}) do
    {:ok, order_group} =
      attrs
      |> Enum.into(%{
        group_name: "some group_name"
      })
      |> BinduBackend.Orders.create_order_group()

    order_group
  end

  @doc """
  Generate a order_item.
  """
  def order_item_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        item_modifier: "some item_modifier",
        menu_item_id: 42,
        notes: "some notes",
        quantity: 42,
        status: "some status",
        unit_price: 120.5
      })

    {:ok, order_item} = BinduBackend.Orders.create_order_item(scope, attrs)
    order_item
  end
end
