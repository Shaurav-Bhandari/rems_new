defmodule BinduBackend.Flags do
  @moduledoc """
  The Flags context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Flags.TableStatus
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any table_status changes.

  The broadcasted messages match the pattern:

    * {:created, %TableStatus{}}
    * {:updated, %TableStatus{}}
    * {:deleted, %TableStatus{}}

  """
  def subscribe_table_statuses(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:table_statuses")
  end

  defp broadcast_table_status(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:table_statuses", message)
  end

  @doc """
  Returns the list of table_statuses.

  ## Examples

      iex> list_table_statuses(scope)
      [%TableStatus{}, ...]

  """
  def list_table_statuses(%Scope{} = _scope) do
    Repo.all(TableStatus)
  end

  @doc """
  Gets a single table_status.

  Raises `Ecto.NoResultsError` if the Table status does not exist.

  ## Examples

      iex> get_table_status!(scope, 123)
      %TableStatus{}

      iex> get_table_status!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_table_status!(%Scope{} = _scope, id) do
    Repo.get!(TableStatus, id)
  end

  @doc """
  Creates a table_status.

  ## Examples

      iex> create_table_status(scope, %{field: value})
      {:ok, %TableStatus{}}

      iex> create_table_status(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_table_status(%Scope{} = scope, attrs) do
    with {:ok, table_status = %TableStatus{}} <-
           %TableStatus{}
           |> TableStatus.changeset(attrs)
           |> Repo.insert() do
      broadcast_table_status(scope, {:created, table_status})
      {:ok, table_status}
    end
  end

  @doc """
  Updates a table_status.

  ## Examples

      iex> update_table_status(scope, table_status, %{field: new_value})
      {:ok, %TableStatus{}}

      iex> update_table_status(scope, table_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_table_status(%Scope{} = scope, %TableStatus{} = table_status, attrs) do
    with {:ok, table_status = %TableStatus{}} <-
           table_status
           |> TableStatus.changeset(attrs)
           |> Repo.update() do
      broadcast_table_status(scope, {:updated, table_status})
      {:ok, table_status}
    end
  end

  @doc """
  Deletes a table_status.

  ## Examples

      iex> delete_table_status(scope, table_status)
      {:ok, %TableStatus{}}

      iex> delete_table_status(scope, table_status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_table_status(%Scope{} = scope, %TableStatus{} = table_status) do
    with {:ok, table_status = %TableStatus{}} <-
           Repo.delete(table_status) do
      broadcast_table_status(scope, {:deleted, table_status})
      {:ok, table_status}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking table_status changes.

  ## Examples

      iex> change_table_status(scope, table_status)
      %Ecto.Changeset{data: %TableStatus{}}

  """
  def change_table_status(%Scope{} = _scope, %TableStatus{} = table_status, attrs \\ %{}) do
    TableStatus.changeset(table_status, attrs)
  end
end
