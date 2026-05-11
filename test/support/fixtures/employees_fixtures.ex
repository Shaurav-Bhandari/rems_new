defmodule BinduBackend.EmployeesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Employees` context.
  """

  @doc """
  Generate a employee.
  """
  def employee_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        department: "some department",
        email: "some email",
        first_name: "some first_name",
        is_active: true,
        last_name: "some last_name",
        phone: "some phone",
        position: "some position",
        rate: 120.5
      })

    {:ok, employee} = BinduBackend.Employees.create_employee(scope, attrs)
    employee
  end
end
