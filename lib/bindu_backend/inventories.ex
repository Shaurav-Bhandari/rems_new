defmodule BinduBackend.Inventories do
  @moduledoc """
  The Inventories context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Inventories.Inventory
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any inventory changes.

  The broadcasted messages match the pattern:

    * {:created, %Inventory{}}
    * {:updated, %Inventory{}}
    * {:deleted, %Inventory{}}

  """
  def subscribe_inventory_item(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:inventory_item")
  end

  defp broadcast_inventory(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:inventory_item", message)
  end

  @doc """
  Returns the list of inventory_item.

  ## Examples

      iex> list_inventory_item(scope)
      [%Inventory{}, ...]

  """
  def list_inventory_item(%Scope{} = scope) do
    Repo.all_by(Inventory, user_id: scope.user.id)
  end

  @doc """
  Gets a single inventory.

  Raises `Ecto.NoResultsError` if the Inventory does not exist.

  ## Examples

      iex> get_inventory!(scope, 123)
      %Inventory{}

      iex> get_inventory!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_inventory!(%Scope{} = scope, id) do
    Repo.get_by!(Inventory, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a inventory.

  ## Examples

      iex> create_inventory(scope, %{field: value})
      {:ok, %Inventory{}}

      iex> create_inventory(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_inventory(%Scope{} = scope, attrs) do
    with {:ok, inventory = %Inventory{}} <-
           %Inventory{}
           |> Inventory.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_inventory(scope, {:created, inventory})
      {:ok, inventory}
    end
  end

  @doc """
  Updates a inventory.

  ## Examples

      iex> update_inventory(scope, inventory, %{field: new_value})
      {:ok, %Inventory{}}

      iex> update_inventory(scope, inventory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inventory(%Scope{} = scope, %Inventory{} = inventory, attrs) do
    true = inventory.user_id == scope.user.id

    with {:ok, inventory = %Inventory{}} <-
           inventory
           |> Inventory.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_inventory(scope, {:updated, inventory})
      {:ok, inventory}
    end
  end

  @doc """
  Deletes a inventory.

  ## Examples

      iex> delete_inventory(scope, inventory)
      {:ok, %Inventory{}}

      iex> delete_inventory(scope, inventory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_inventory(%Scope{} = scope, %Inventory{} = inventory) do
    true = inventory.user_id == scope.user.id

    with {:ok, inventory = %Inventory{}} <-
           Repo.delete(inventory) do
      broadcast_inventory(scope, {:deleted, inventory})
      {:ok, inventory}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking inventory changes.

  ## Examples

      iex> change_inventory(scope, inventory)
      %Ecto.Changeset{data: %Inventory{}}

  """
  def change_inventory(%Scope{} = scope, %Inventory{} = inventory, attrs \\ %{}) do
    true = inventory.user_id == scope.user.id

    Inventory.changeset(inventory, attrs, scope)
  end
end
