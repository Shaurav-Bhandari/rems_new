defmodule BinduBackend.OrdersTest do
  use BinduBackend.DataCase

  alias BinduBackend.Orders

  describe "orders" do
    alias BinduBackend.Orders.Order

    import BinduBackend.OrdersFixtures

    @invalid_attrs %{
      taken_by_id: nil,
      sub_total: nil,
      service_charge: nil,
      order_status: nil,
      order_type: nil,
      total_amount: nil,
      notes: nil
    }

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
        taken_by_id: "7488a646-e31f-11e4-aace-600308960662",
        sub_total: 120.5,
        service_charge: 120.5,
        order_status: "some order_status",
        order_type: "some order_type",
        total_amount: 120.5,
        notes: "some notes"
      }

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.taken_by_id == "7488a646-e31f-11e4-aace-600308960662"
      assert order.sub_total == 120.5
      assert order.service_charge == 120.5
      assert order.order_status == "some order_status"
      assert order.order_type == "some order_type"
      assert order.total_amount == 120.5
      assert order.notes == "some notes"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()

      update_attrs = %{
        taken_by_id: "7488a646-e31f-11e4-aace-600308960668",
        sub_total: 456.7,
        service_charge: 456.7,
        order_status: "some updated order_status",
        order_type: "some updated order_type",
        total_amount: 456.7,
        notes: "some updated notes"
      }

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.taken_by_id == "7488a646-e31f-11e4-aace-600308960668"
      assert order.sub_total == 456.7
      assert order.service_charge == 456.7
      assert order.order_status == "some updated order_status"
      assert order.order_type == "some updated order_type"
      assert order.total_amount == 456.7
      assert order.notes == "some updated notes"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end

  describe "order_groups" do
    alias BinduBackend.Orders.OrderGroup

    import BinduBackend.OrdersFixtures

    @invalid_attrs %{group_name: nil}

    test "list_order_groups/0 returns all order_groups" do
      order_group = order_group_fixture()
      assert Orders.list_order_groups() == [order_group]
    end

    test "get_order_group!/1 returns the order_group with given id" do
      order_group = order_group_fixture()
      assert Orders.get_order_group!(order_group.id) == order_group
    end

    test "create_order_group/1 with valid data creates a order_group" do
      valid_attrs = %{group_name: "some group_name"}

      assert {:ok, %OrderGroup{} = order_group} = Orders.create_order_group(valid_attrs)
      assert order_group.group_name == "some group_name"
    end

    test "create_order_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order_group(@invalid_attrs)
    end

    test "update_order_group/2 with valid data updates the order_group" do
      order_group = order_group_fixture()
      update_attrs = %{group_name: "some updated group_name"}

      assert {:ok, %OrderGroup{} = order_group} =
               Orders.update_order_group(order_group, update_attrs)

      assert order_group.group_name == "some updated group_name"
    end

    test "update_order_group/2 with invalid data returns error changeset" do
      order_group = order_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order_group(order_group, @invalid_attrs)
      assert order_group == Orders.get_order_group!(order_group.id)
    end

    test "delete_order_group/1 deletes the order_group" do
      order_group = order_group_fixture()
      assert {:ok, %OrderGroup{}} = Orders.delete_order_group(order_group)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_group!(order_group.id) end
    end

    test "change_order_group/1 returns a order_group changeset" do
      order_group = order_group_fixture()
      assert %Ecto.Changeset{} = Orders.change_order_group(order_group)
    end
  end

  describe "order_items" do
    alias BinduBackend.Orders.OrderItem

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.OrdersFixtures

    @invalid_attrs %{
      status: nil,
      quantity: nil,
      menu_item_id: nil,
      unit_price: nil,
      notes: nil,
      item_modifier: nil
    }

    test "list_order_items/1 returns all scoped order_items" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      order_item = order_item_fixture(scope)
      other_order_item = order_item_fixture(other_scope)
      assert Orders.list_order_items(scope) == [order_item]
      assert Orders.list_order_items(other_scope) == [other_order_item]
    end

    test "get_order_item!/2 returns the order_item with given id" do
      scope = user_scope_fixture()
      order_item = order_item_fixture(scope)
      other_scope = user_scope_fixture()
      assert Orders.get_order_item!(scope, order_item.id) == order_item

      assert_raise Ecto.NoResultsError, fn ->
        Orders.get_order_item!(other_scope, order_item.id)
      end
    end

    test "create_order_item/2 with valid data creates a order_item" do
      valid_attrs = %{
        status: "some status",
        quantity: 42,
        menu_item_id: 42,
        unit_price: 120.5,
        notes: "some notes",
        item_modifier: "some item_modifier"
      }

      scope = user_scope_fixture()

      assert {:ok, %OrderItem{} = order_item} = Orders.create_order_item(scope, valid_attrs)
      assert order_item.status == "some status"
      assert order_item.quantity == 42
      assert order_item.menu_item_id == 42
      assert order_item.unit_price == 120.5
      assert order_item.notes == "some notes"
      assert order_item.item_modifier == "some item_modifier"
      assert order_item.user_id == scope.user.id
    end

    test "create_order_item/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.create_order_item(scope, @invalid_attrs)
    end

    test "update_order_item/3 with valid data updates the order_item" do
      scope = user_scope_fixture()
      order_item = order_item_fixture(scope)

      update_attrs = %{
        status: "some updated status",
        quantity: 43,
        menu_item_id: 43,
        unit_price: 456.7,
        notes: "some updated notes",
        item_modifier: "some updated item_modifier"
      }

      assert {:ok, %OrderItem{} = order_item} =
               Orders.update_order_item(scope, order_item, update_attrs)

      assert order_item.status == "some updated status"
      assert order_item.quantity == 43
      assert order_item.menu_item_id == 43
      assert order_item.unit_price == 456.7
      assert order_item.notes == "some updated notes"
      assert order_item.item_modifier == "some updated item_modifier"
    end

    test "update_order_item/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      order_item = order_item_fixture(scope)

      assert_raise MatchError, fn ->
        Orders.update_order_item(other_scope, order_item, %{})
      end
    end

    test "update_order_item/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      order_item = order_item_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Orders.update_order_item(scope, order_item, @invalid_attrs)

      assert order_item == Orders.get_order_item!(scope, order_item.id)
    end

    test "delete_order_item/2 deletes the order_item" do
      scope = user_scope_fixture()
      order_item = order_item_fixture(scope)
      assert {:ok, %OrderItem{}} = Orders.delete_order_item(scope, order_item)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order_item!(scope, order_item.id) end
    end

    test "delete_order_item/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      order_item = order_item_fixture(scope)
      assert_raise MatchError, fn -> Orders.delete_order_item(other_scope, order_item) end
    end

    test "change_order_item/2 returns a order_item changeset" do
      scope = user_scope_fixture()
      order_item = order_item_fixture(scope)
      assert %Ecto.Changeset{} = Orders.change_order_item(scope, order_item)
    end
  end
end
