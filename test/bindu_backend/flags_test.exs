defmodule BinduBackend.FlagsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Flags

  describe "table_statuses" do
    alias BinduBackend.Flags.TableStatus

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.FlagsFixtures

    @invalid_attrs %{name: nil, description: nil, is_default: nil, is_system: nil, is_active: nil}

    test "list_table_statuses/1 returns all scoped table_statuses" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      table_status = table_status_fixture(scope)
      other_table_status = table_status_fixture(other_scope)
      assert Flags.list_table_statuses(scope) == [table_status]
      assert Flags.list_table_statuses(other_scope) == [other_table_status]
    end

    test "get_table_status!/2 returns the table_status with given id" do
      scope = user_scope_fixture()
      table_status = table_status_fixture(scope)
      other_scope = user_scope_fixture()
      assert Flags.get_table_status!(scope, table_status.id) == table_status

      assert_raise Ecto.NoResultsError, fn ->
        Flags.get_table_status!(other_scope, table_status.id)
      end
    end

    test "create_table_status/2 with valid data creates a table_status" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        is_default: true,
        is_system: true,
        is_active: true
      }

      scope = user_scope_fixture()

      assert {:ok, %TableStatus{} = table_status} = Flags.create_table_status(scope, valid_attrs)
      assert table_status.name == "some name"
      assert table_status.description == "some description"
      assert table_status.is_default == true
      assert table_status.is_system == true
      assert table_status.is_active == true
      assert table_status.user_id == scope.user.id
    end

    test "create_table_status/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Flags.create_table_status(scope, @invalid_attrs)
    end

    test "update_table_status/3 with valid data updates the table_status" do
      scope = user_scope_fixture()
      table_status = table_status_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        is_default: false,
        is_system: false,
        is_active: false
      }

      assert {:ok, %TableStatus{} = table_status} =
               Flags.update_table_status(scope, table_status, update_attrs)

      assert table_status.name == "some updated name"
      assert table_status.description == "some updated description"
      assert table_status.is_default == false
      assert table_status.is_system == false
      assert table_status.is_active == false
    end

    test "update_table_status/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      table_status = table_status_fixture(scope)

      assert_raise MatchError, fn ->
        Flags.update_table_status(other_scope, table_status, %{})
      end
    end

    test "update_table_status/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      table_status = table_status_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Flags.update_table_status(scope, table_status, @invalid_attrs)

      assert table_status == Flags.get_table_status!(scope, table_status.id)
    end

    test "delete_table_status/2 deletes the table_status" do
      scope = user_scope_fixture()
      table_status = table_status_fixture(scope)
      assert {:ok, %TableStatus{}} = Flags.delete_table_status(scope, table_status)
      assert_raise Ecto.NoResultsError, fn -> Flags.get_table_status!(scope, table_status.id) end
    end

    test "delete_table_status/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      table_status = table_status_fixture(scope)
      assert_raise MatchError, fn -> Flags.delete_table_status(other_scope, table_status) end
    end

    test "change_table_status/2 returns a table_status changeset" do
      scope = user_scope_fixture()
      table_status = table_status_fixture(scope)
      assert %Ecto.Changeset{} = Flags.change_table_status(scope, table_status)
    end
  end
end
