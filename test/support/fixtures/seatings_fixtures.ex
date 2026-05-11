defmodule BinduBackend.SeatingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Seatings` context.
  """

  @doc """
  Generate a floor.
  """
  def floor_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        code: "some code",
        description: "some description",
        display_order: 42,
        name: "some name"
      })

    {:ok, floor} = BinduBackend.Seatings.create_floor(scope, attrs)
    floor
  end
end
