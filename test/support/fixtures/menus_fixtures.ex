defmodule BinduBackend.MenusFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Menus` context.
  """

  @doc """
  Generate a menu.
  """
  def menu_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        category_image_url: "some category_image_url",
        description: "some description",
        display_order: 42,
        is_active: true,
        name: "some name"
      })

    {:ok, menu} = BinduBackend.Menus.create_menu(scope, attrs)
    menu
  end
end
