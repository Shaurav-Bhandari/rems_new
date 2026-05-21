defmodule BinduBackend.EmployeesTest do
  use BinduBackend.DataCase

  alias BinduBackend.Employees

  describe "emnployee" do
    alias BinduBackend.Employees.Employee

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.EmployeesFixtures

    @invalid_attrs %{
      position: nil,
      first_name: nil,
      last_name: nil,
      email: nil,
      phone: nil,
      department: nil,
      rate: nil,
      is_active: nil
    }

    test "list_emnployee/1 returns all scoped emnployee" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      employee = employee_fixture(scope)
      other_employee = employee_fixture(other_scope)
      assert Employees.list_emnployee(scope) == [employee]
      assert Employees.list_emnployee(other_scope) == [other_employee]
    end

    test "get_employee!/2 returns the employee with given id" do
      scope = user_scope_fixture()
      employee = employee_fixture(scope)
      other_scope = user_scope_fixture()
      assert Employees.get_employee!(scope, employee.id) == employee

      assert_raise Ecto.NoResultsError, fn ->
        Employees.get_employee!(other_scope, employee.id)
      end
    end

    test "create_employee/2 with valid data creates a employee" do
      valid_attrs = %{
        position: "some position",
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some email",
        phone: "some phone",
        department: "some department",
        rate: 120.5,
        is_active: true
      }

      scope = user_scope_fixture()

      assert {:ok, %Employee{} = employee} = Employees.create_employee(scope, valid_attrs)
      assert employee.position == "some position"
      assert employee.first_name == "some first_name"
      assert employee.last_name == "some last_name"
      assert employee.email == "some email"
      assert employee.phone == "some phone"
      assert employee.department == "some department"
      assert employee.rate == 120.5
      assert employee.is_active == true
      assert employee.user_id == scope.user.id
    end

    test "create_employee/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(scope, @invalid_attrs)
    end

    test "update_employee/3 with valid data updates the employee" do
      scope = user_scope_fixture()
      employee = employee_fixture(scope)

      update_attrs = %{
        position: "some updated position",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        email: "some updated email",
        phone: "some updated phone",
        department: "some updated department",
        rate: 456.7,
        is_active: false
      }

      assert {:ok, %Employee{} = employee} =
               Employees.update_employee(scope, employee, update_attrs)

      assert employee.position == "some updated position"
      assert employee.first_name == "some updated first_name"
      assert employee.last_name == "some updated last_name"
      assert employee.email == "some updated email"
      assert employee.phone == "some updated phone"
      assert employee.department == "some updated department"
      assert employee.rate == 456.7
      assert employee.is_active == false
    end

    test "update_employee/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      employee = employee_fixture(scope)

      assert_raise MatchError, fn ->
        Employees.update_employee(other_scope, employee, %{})
      end
    end

    test "update_employee/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      employee = employee_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Employees.update_employee(scope, employee, @invalid_attrs)

      assert employee == Employees.get_employee!(scope, employee.id)
    end

    test "delete_employee/2 deletes the employee" do
      scope = user_scope_fixture()
      employee = employee_fixture(scope)
      assert {:ok, %Employee{}} = Employees.delete_employee(scope, employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(scope, employee.id) end
    end

    test "delete_employee/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      employee = employee_fixture(scope)
      assert_raise MatchError, fn -> Employees.delete_employee(other_scope, employee) end
    end

    test "change_employee/2 returns a employee changeset" do
      scope = user_scope_fixture()
      employee = employee_fixture(scope)
      assert %Ecto.Changeset{} = Employees.change_employee(scope, employee)
    end
  end
end
