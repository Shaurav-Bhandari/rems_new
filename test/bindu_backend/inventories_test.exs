defmodule BinduBackend.InventoriesTest do
  use BinduBackend.DataCase

  alias BinduBackend.Inventories

  describe "inventory_item" do
    alias BinduBackend.Inventories.Inventory

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.InventoriesFixtures

    @invalid_attrs %{
      name: nil,
      description: nil,
      category: nil,
      sku: nil,
      measurement_unit: nil,
      current_quantity: nil,
      minimum_quantity: nil,
      maximum_quantity: nil,
      reorder_point: nil,
      unit_cost: nil,
      last_restock_date: nil
    }

    test "list_inventory_item/1 returns all scoped inventory_item" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      inventory = inventory_fixture(scope)
      other_inventory = inventory_fixture(other_scope)
      assert Inventories.list_inventory_item(scope) == [inventory]
      assert Inventories.list_inventory_item(other_scope) == [other_inventory]
    end

    test "get_inventory!/2 returns the inventory with given id" do
      scope = user_scope_fixture()
      inventory = inventory_fixture(scope)
      other_scope = user_scope_fixture()
      assert Inventories.get_inventory!(scope, inventory.id) == inventory

      assert_raise Ecto.NoResultsError, fn ->
        Inventories.get_inventory!(other_scope, inventory.id)
      end
    end

    test "create_inventory/2 with valid data creates a inventory" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        category: "some category",
        sku: "some sku",
        measurement_unit: "some measurement_unit",
        current_quantity: 120.5,
        minimum_quantity: 120.5,
        maximum_quantity: 120.5,
        reorder_point: 120.5,
        unit_cost: 120.5,
        last_restock_date: ~D[2026-05-09]
      }

      scope = user_scope_fixture()

      assert {:ok, %Inventory{} = inventory} = Inventories.create_inventory(scope, valid_attrs)
      assert inventory.name == "some name"
      assert inventory.description == "some description"
      assert inventory.category == "some category"
      assert inventory.sku == "some sku"
      assert inventory.measurement_unit == "some measurement_unit"
      assert inventory.current_quantity == 120.5
      assert inventory.minimum_quantity == 120.5
      assert inventory.maximum_quantity == 120.5
      assert inventory.reorder_point == 120.5
      assert inventory.unit_cost == 120.5
      assert inventory.last_restock_date == ~D[2026-05-09]
      assert inventory.user_id == scope.user.id
    end

    test "create_inventory/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventories.create_inventory(scope, @invalid_attrs)
    end

    test "update_inventory/3 with valid data updates the inventory" do
      scope = user_scope_fixture()
      inventory = inventory_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        category: "some updated category",
        sku: "some updated sku",
        measurement_unit: "some updated measurement_unit",
        current_quantity: 456.7,
        minimum_quantity: 456.7,
        maximum_quantity: 456.7,
        reorder_point: 456.7,
        unit_cost: 456.7,
        last_restock_date: ~D[2026-05-10]
      }

      assert {:ok, %Inventory{} = inventory} =
               Inventories.update_inventory(scope, inventory, update_attrs)

      assert inventory.name == "some updated name"
      assert inventory.description == "some updated description"
      assert inventory.category == "some updated category"
      assert inventory.sku == "some updated sku"
      assert inventory.measurement_unit == "some updated measurement_unit"
      assert inventory.current_quantity == 456.7
      assert inventory.minimum_quantity == 456.7
      assert inventory.maximum_quantity == 456.7
      assert inventory.reorder_point == 456.7
      assert inventory.unit_cost == 456.7
      assert inventory.last_restock_date == ~D[2026-05-10]
    end

    test "update_inventory/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      inventory = inventory_fixture(scope)

      assert_raise MatchError, fn ->
        Inventories.update_inventory(other_scope, inventory, %{})
      end
    end

    test "update_inventory/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      inventory = inventory_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Inventories.update_inventory(scope, inventory, @invalid_attrs)

      assert inventory == Inventories.get_inventory!(scope, inventory.id)
    end

    test "delete_inventory/2 deletes the inventory" do
      scope = user_scope_fixture()
      inventory = inventory_fixture(scope)
      assert {:ok, %Inventory{}} = Inventories.delete_inventory(scope, inventory)
      assert_raise Ecto.NoResultsError, fn -> Inventories.get_inventory!(scope, inventory.id) end
    end

    test "delete_inventory/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      inventory = inventory_fixture(scope)
      assert_raise MatchError, fn -> Inventories.delete_inventory(other_scope, inventory) end
    end

    test "change_inventory/2 returns a inventory changeset" do
      scope = user_scope_fixture()
      inventory = inventory_fixture(scope)
      assert %Ecto.Changeset{} = Inventories.change_inventory(scope, inventory)
    end
  end
end
