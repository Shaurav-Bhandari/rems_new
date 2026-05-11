defmodule BinduBackend.CustomersTest do
  use BinduBackend.DataCase

  alias BinduBackend.Customers

  describe "customers" do
    alias BinduBackend.Customers.Customer

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.CustomersFixtures

    @invalid_attrs %{first_name: nil, last_name: nil, email: nil, contact_number: nil, total_orders: nil, loyalty_points: nil, total_spent: nil, is_active: nil}

    test "list_customers/1 returns all scoped customers" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      customer = customer_fixture(scope)
      other_customer = customer_fixture(other_scope)
      assert Customers.list_customers(scope) == [customer]
      assert Customers.list_customers(other_scope) == [other_customer]
    end

    test "get_customer!/2 returns the customer with given id" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      other_scope = user_scope_fixture()
      assert Customers.get_customer!(scope, customer.id) == customer
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(other_scope, customer.id) end
    end

    test "create_customer/2 with valid data creates a customer" do
      valid_attrs = %{first_name: "some first_name", last_name: "some last_name", email: "some email", contact_number: "some contact_number", total_orders: 42, loyalty_points: 42, total_spent: 120.5, is_active: true}
      scope = user_scope_fixture()

      assert {:ok, %Customer{} = customer} = Customers.create_customer(scope, valid_attrs)
      assert customer.first_name == "some first_name"
      assert customer.last_name == "some last_name"
      assert customer.email == "some email"
      assert customer.contact_number == "some contact_number"
      assert customer.total_orders == 42
      assert customer.loyalty_points == 42
      assert customer.total_spent == 120.5
      assert customer.is_active == true
      assert customer.user_id == scope.user.id
    end

    test "create_customer/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(scope, @invalid_attrs)
    end

    test "update_customer/3 with valid data updates the customer" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      update_attrs = %{first_name: "some updated first_name", last_name: "some updated last_name", email: "some updated email", contact_number: "some updated contact_number", total_orders: 43, loyalty_points: 43, total_spent: 456.7, is_active: false}

      assert {:ok, %Customer{} = customer} = Customers.update_customer(scope, customer, update_attrs)
      assert customer.first_name == "some updated first_name"
      assert customer.last_name == "some updated last_name"
      assert customer.email == "some updated email"
      assert customer.contact_number == "some updated contact_number"
      assert customer.total_orders == 43
      assert customer.loyalty_points == 43
      assert customer.total_spent == 456.7
      assert customer.is_active == false
    end

    test "update_customer/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      customer = customer_fixture(scope)

      assert_raise MatchError, fn ->
        Customers.update_customer(other_scope, customer, %{})
      end
    end

    test "update_customer/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(scope, customer, @invalid_attrs)
      assert customer == Customers.get_customer!(scope, customer.id)
    end

    test "delete_customer/2 deletes the customer" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert {:ok, %Customer{}} = Customers.delete_customer(scope, customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(scope, customer.id) end
    end

    test "delete_customer/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert_raise MatchError, fn -> Customers.delete_customer(other_scope, customer) end
    end

    test "change_customer/2 returns a customer changeset" do
      scope = user_scope_fixture()
      customer = customer_fixture(scope)
      assert %Ecto.Changeset{} = Customers.change_customer(scope, customer)
    end
  end
end
