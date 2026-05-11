defmodule BinduBackend.SeatingsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Seatings

  describe "floors" do
    alias BinduBackend.Seatings.Floor

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.SeatingsFixtures

    @invalid_attrs %{code: nil, name: nil, description: nil, display_order: nil}

    test "list_floors/1 returns all scoped floors" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      floor = floor_fixture(scope)
      other_floor = floor_fixture(other_scope)
      assert Seatings.list_floors(scope) == [floor]
      assert Seatings.list_floors(other_scope) == [other_floor]
    end

    test "get_floor!/2 returns the floor with given id" do
      scope = user_scope_fixture()
      floor = floor_fixture(scope)
      other_scope = user_scope_fixture()
      assert Seatings.get_floor!(scope, floor.id) == floor
      assert_raise Ecto.NoResultsError, fn -> Seatings.get_floor!(other_scope, floor.id) end
    end

    test "create_floor/2 with valid data creates a floor" do
      valid_attrs = %{code: "some code", name: "some name", description: "some description", display_order: 42}
      scope = user_scope_fixture()

      assert {:ok, %Floor{} = floor} = Seatings.create_floor(scope, valid_attrs)
      assert floor.code == "some code"
      assert floor.name == "some name"
      assert floor.description == "some description"
      assert floor.display_order == 42
      assert floor.user_id == scope.user.id
    end

    test "create_floor/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Seatings.create_floor(scope, @invalid_attrs)
    end

    test "update_floor/3 with valid data updates the floor" do
      scope = user_scope_fixture()
      floor = floor_fixture(scope)
      update_attrs = %{code: "some updated code", name: "some updated name", description: "some updated description", display_order: 43}

      assert {:ok, %Floor{} = floor} = Seatings.update_floor(scope, floor, update_attrs)
      assert floor.code == "some updated code"
      assert floor.name == "some updated name"
      assert floor.description == "some updated description"
      assert floor.display_order == 43
    end

    test "update_floor/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      floor = floor_fixture(scope)

      assert_raise MatchError, fn ->
        Seatings.update_floor(other_scope, floor, %{})
      end
    end

    test "update_floor/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      floor = floor_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Seatings.update_floor(scope, floor, @invalid_attrs)
      assert floor == Seatings.get_floor!(scope, floor.id)
    end

    test "delete_floor/2 deletes the floor" do
      scope = user_scope_fixture()
      floor = floor_fixture(scope)
      assert {:ok, %Floor{}} = Seatings.delete_floor(scope, floor)
      assert_raise Ecto.NoResultsError, fn -> Seatings.get_floor!(scope, floor.id) end
    end

    test "delete_floor/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      floor = floor_fixture(scope)
      assert_raise MatchError, fn -> Seatings.delete_floor(other_scope, floor) end
    end

    test "change_floor/2 returns a floor changeset" do
      scope = user_scope_fixture()
      floor = floor_fixture(scope)
      assert %Ecto.Changeset{} = Seatings.change_floor(scope, floor)
    end
  end
end
