defmodule BinduBackend.CustomersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Customers` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        contact_number: "some contact_number",
        email: "some email",
        first_name: "some first_name",
        is_active: true,
        last_name: "some last_name",
        loyalty_points: 42,
        total_orders: 42,
        total_spent: 120.5
      })

    {:ok, customer} = BinduBackend.Customers.create_customer(scope, attrs)
    customer
  end
end
