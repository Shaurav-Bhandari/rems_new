defmodule BinduBackend.KotsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Kots

  describe "kots" do
    alias BinduBackend.Kot.Kot

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.KotsFixtures

    @invalid_attrs %{
      status: nil,
      kot_number: nil,
      sequence_number: nil,
      order_number: nil,
      table_number: nil,
      customer_name: nil,
      order_type: nil,
      guest_count: nil,
      print_count: nil
    }

    test "list_kots/1 returns all scoped kots" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      kot = kot_fixture(scope)
      other_kot = kot_fixture(other_scope)
      assert Kots.list_kots(scope) == [kot]
      assert Kots.list_kots(other_scope) == [other_kot]
    end

    test "get_kot!/2 returns the kot with given id" do
      scope = user_scope_fixture()
      kot = kot_fixture(scope)
      other_scope = user_scope_fixture()
      assert Kots.get_kot!(scope, kot.id) == kot
      assert_raise Ecto.NoResultsError, fn -> Kots.get_kot!(other_scope, kot.id) end
    end

    test "create_kot/2 with valid data creates a kot" do
      valid_attrs = %{
        status: true,
        kot_number: "some kot_number",
        sequence_number: 42,
        order_number: "some order_number",
        table_number: 42,
        customer_name: "some customer_name",
        order_type: "some order_type",
        guest_count: 42,
        print_count: 42
      }

      scope = user_scope_fixture()

      assert {:ok, %Kot{} = kot} = Kots.create_kot(scope, valid_attrs)
      assert kot.status == true
      assert kot.kot_number == "some kot_number"
      assert kot.sequence_number == 42
      assert kot.order_number == "some order_number"
      assert kot.table_number == 42
      assert kot.customer_name == "some customer_name"
      assert kot.order_type == "some order_type"
      assert kot.guest_count == 42
      assert kot.print_count == 42
      assert kot.user_id == scope.user.id
    end

    test "create_kot/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Kots.create_kot(scope, @invalid_attrs)
    end

    test "update_kot/3 with valid data updates the kot" do
      scope = user_scope_fixture()
      kot = kot_fixture(scope)

      update_attrs = %{
        status: false,
        kot_number: "some updated kot_number",
        sequence_number: 43,
        order_number: "some updated order_number",
        table_number: 43,
        customer_name: "some updated customer_name",
        order_type: "some updated order_type",
        guest_count: 43,
        print_count: 43
      }

      assert {:ok, %Kot{} = kot} = Kots.update_kot(scope, kot, update_attrs)
      assert kot.status == false
      assert kot.kot_number == "some updated kot_number"
      assert kot.sequence_number == 43
      assert kot.order_number == "some updated order_number"
      assert kot.table_number == 43
      assert kot.customer_name == "some updated customer_name"
      assert kot.order_type == "some updated order_type"
      assert kot.guest_count == 43
      assert kot.print_count == 43
    end

    test "update_kot/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      kot = kot_fixture(scope)

      assert_raise MatchError, fn ->
        Kots.update_kot(other_scope, kot, %{})
      end
    end

    test "update_kot/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      kot = kot_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Kots.update_kot(scope, kot, @invalid_attrs)
      assert kot == Kots.get_kot!(scope, kot.id)
    end

    test "delete_kot/2 deletes the kot" do
      scope = user_scope_fixture()
      kot = kot_fixture(scope)
      assert {:ok, %Kot{}} = Kots.delete_kot(scope, kot)
      assert_raise Ecto.NoResultsError, fn -> Kots.get_kot!(scope, kot.id) end
    end

    test "delete_kot/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      kot = kot_fixture(scope)
      assert_raise MatchError, fn -> Kots.delete_kot(other_scope, kot) end
    end

    test "change_kot/2 returns a kot changeset" do
      scope = user_scope_fixture()
      kot = kot_fixture(scope)
      assert %Ecto.Changeset{} = Kots.change_kot(scope, kot)
    end
  end
end
