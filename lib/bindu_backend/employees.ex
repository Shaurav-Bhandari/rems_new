defmodule BinduBackend.Employees do
  @moduledoc """
  The Employees context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Employees.Employee
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any employee changes.

  The broadcasted messages match the pattern:

    * {:created, %Employee{}}
    * {:updated, %Employee{}}
    * {:deleted, %Employee{}}

  """
  def subscribe_emnployee(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:emnployee")
  end

  defp broadcast_employee(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:emnployee", message)
  end

  @doc """
  Returns the list of emnployee.

  ## Examples

      iex> list_emnployee(scope)
      [%Employee{}, ...]

  """
  def list_emnployee(%Scope{} = scope) do
    Repo.all_by(Employee, user_id: scope.user.id)
  end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(scope, 123)
      %Employee{}

      iex> get_employee!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(%Scope{} = scope, id) do
    Repo.get_by!(Employee, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(scope, %{field: value})
      {:ok, %Employee{}}

      iex> create_employee(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(%Scope{} = scope, attrs) do
    with {:ok, employee = %Employee{}} <-
           %Employee{}
           |> Employee.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_employee(scope, {:created, employee})
      {:ok, employee}
    end
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(scope, employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(scope, employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Scope{} = scope, %Employee{} = employee, attrs) do
    true = employee.user_id == scope.user.id

    with {:ok, employee = %Employee{}} <-
           employee
           |> Employee.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_employee(scope, {:updated, employee})
      {:ok, employee}
    end
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(scope, employee)
      {:ok, %Employee{}}

      iex> delete_employee(scope, employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Scope{} = scope, %Employee{} = employee) do
    true = employee.user_id == scope.user.id

    with {:ok, employee = %Employee{}} <-
           Repo.delete(employee) do
      broadcast_employee(scope, {:deleted, employee})
      {:ok, employee}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(scope, employee)
      %Ecto.Changeset{data: %Employee{}}

  """
  def change_employee(%Scope{} = scope, %Employee{} = employee, attrs \\ %{}) do
    true = employee.user_id == scope.user.id

    Employee.changeset(employee, attrs, scope)
  end
end
