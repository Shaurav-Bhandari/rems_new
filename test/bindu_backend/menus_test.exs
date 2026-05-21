defmodule BinduBackend.MenusTest do
  use BinduBackend.DataCase

  alias BinduBackend.Menus

  describe "menus_category" do
    alias BinduBackend.Menus.Menu

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.MenusFixtures

    @invalid_attrs %{
      name: nil,
      description: nil,
      display_order: nil,
      is_active: nil,
      category_image_url: nil
    }

    test "list_menus_category/1 returns all scoped menus_category" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      menu = menu_fixture(scope)
      other_menu = menu_fixture(other_scope)
      assert Menus.list_menus_category(scope) == [menu]
      assert Menus.list_menus_category(other_scope) == [other_menu]
    end

    test "get_menu!/2 returns the menu with given id" do
      scope = user_scope_fixture()
      menu = menu_fixture(scope)
      other_scope = user_scope_fixture()
      assert Menus.get_menu!(scope, menu.id) == menu
      assert_raise Ecto.NoResultsError, fn -> Menus.get_menu!(other_scope, menu.id) end
    end

    test "create_menu/2 with valid data creates a menu" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        display_order: 42,
        is_active: true,
        category_image_url: "some category_image_url"
      }

      scope = user_scope_fixture()

      assert {:ok, %Menu{} = menu} = Menus.create_menu(scope, valid_attrs)
      assert menu.name == "some name"
      assert menu.description == "some description"
      assert menu.display_order == 42
      assert menu.is_active == true
      assert menu.category_image_url == "some category_image_url"
      assert menu.user_id == scope.user.id
    end

    test "create_menu/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Menus.create_menu(scope, @invalid_attrs)
    end

    test "update_menu/3 with valid data updates the menu" do
      scope = user_scope_fixture()
      menu = menu_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        display_order: 43,
        is_active: false,
        category_image_url: "some updated category_image_url"
      }

      assert {:ok, %Menu{} = menu} = Menus.update_menu(scope, menu, update_attrs)
      assert menu.name == "some updated name"
      assert menu.description == "some updated description"
      assert menu.display_order == 43
      assert menu.is_active == false
      assert menu.category_image_url == "some updated category_image_url"
    end

    test "update_menu/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      menu = menu_fixture(scope)

      assert_raise MatchError, fn ->
        Menus.update_menu(other_scope, menu, %{})
      end
    end

    test "update_menu/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      menu = menu_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Menus.update_menu(scope, menu, @invalid_attrs)
      assert menu == Menus.get_menu!(scope, menu.id)
    end

    test "delete_menu/2 deletes the menu" do
      scope = user_scope_fixture()
      menu = menu_fixture(scope)
      assert {:ok, %Menu{}} = Menus.delete_menu(scope, menu)
      assert_raise Ecto.NoResultsError, fn -> Menus.get_menu!(scope, menu.id) end
    end

    test "delete_menu/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      menu = menu_fixture(scope)
      assert_raise MatchError, fn -> Menus.delete_menu(other_scope, menu) end
    end

    test "change_menu/2 returns a menu changeset" do
      scope = user_scope_fixture()
      menu = menu_fixture(scope)
      assert %Ecto.Changeset{} = Menus.change_menu(scope, menu)
    end
  end
end
