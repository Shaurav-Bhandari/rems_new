defmodule BinduBackend.FlagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Flags` context.
  """

  @doc """
  Generate a table_status.
  """
  def table_status_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        is_active: true,
        is_default: true,
        is_system: true,
        name: "some name"
      })

    {:ok, table_status} = BinduBackend.Flags.create_table_status(scope, attrs)
    table_status
  end
end
