defmodule BinduBackend.KotsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Kots` context.
  """

  @doc """
  Generate a kot.
  """
  def kot_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        customer_name: "some customer_name",
        guest_count: 42,
        kot_number: "some kot_number",
        order_number: "some order_number",
        order_type: "some order_type",
        print_count: 42,
        sequence_number: 42,
        status: true,
        table_number: 42
      })

    {:ok, kot} = BinduBackend.Kots.create_kot(scope, attrs)
    kot
  end
end
