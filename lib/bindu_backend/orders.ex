defmodule BinduBackend.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Orders.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  alias BinduBackend.Orders.OrderGroup

  @doc """
  Returns the list of order_groups.

  ## Examples

      iex> list_order_groups()
      [%OrderGroup{}, ...]

  """
  def list_order_groups do
    Repo.all(OrderGroup)
  end

  @doc """
  Gets a single order_group.

  Raises `Ecto.NoResultsError` if the Order group does not exist.

  ## Examples

      iex> get_order_group!(123)
      %OrderGroup{}

      iex> get_order_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_group!(id), do: Repo.get!(OrderGroup, id)

  @doc """
  Creates a order_group.

  ## Examples

      iex> create_order_group(%{field: value})
      {:ok, %OrderGroup{}}

      iex> create_order_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_group(attrs) do
    %OrderGroup{}
    |> OrderGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_group.

  ## Examples

      iex> update_order_group(order_group, %{field: new_value})
      {:ok, %OrderGroup{}}

      iex> update_order_group(order_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_group(%OrderGroup{} = order_group, attrs) do
    order_group
    |> OrderGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order_group.

  ## Examples

      iex> delete_order_group(order_group)
      {:ok, %OrderGroup{}}

      iex> delete_order_group(order_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_group(%OrderGroup{} = order_group) do
    Repo.delete(order_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_group changes.

  ## Examples

      iex> change_order_group(order_group)
      %Ecto.Changeset{data: %OrderGroup{}}

  """
  def change_order_group(%OrderGroup{} = order_group, attrs \\ %{}) do
    OrderGroup.changeset(order_group, attrs)
  end

  alias BinduBackend.Orders.OrderItem
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any order_item changes.

  The broadcasted messages match the pattern:

    * {:created, %OrderItem{}}
    * {:updated, %OrderItem{}}
    * {:deleted, %OrderItem{}}

  """
  def subscribe_order_items(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:order_items")
  end

  defp broadcast_order_item(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:order_items", message)
  end

  @doc """
  Returns the list of order_items.

  ## Examples

      iex> list_order_items(scope)
      [%OrderItem{}, ...]

  """
  def list_order_items(%Scope{} = scope) do
    Repo.all_by(OrderItem, user_id: scope.user.id)
  end

  @doc """
  Gets a single order_item.

  Raises `Ecto.NoResultsError` if the Order item does not exist.

  ## Examples

      iex> get_order_item!(scope, 123)
      %OrderItem{}

      iex> get_order_item!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_order_item!(%Scope{} = scope, id) do
    Repo.get_by!(OrderItem, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a order_item.

  ## Examples

      iex> create_order_item(scope, %{field: value})
      {:ok, %OrderItem{}}

      iex> create_order_item(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_item(%Scope{} = scope, attrs) do
    with {:ok, order_item = %OrderItem{}} <-
           %OrderItem{}
           |> OrderItem.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_order_item(scope, {:created, order_item})
      {:ok, order_item}
    end
  end

  @doc """
  Updates a order_item.

  ## Examples

      iex> update_order_item(scope, order_item, %{field: new_value})
      {:ok, %OrderItem{}}

      iex> update_order_item(scope, order_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_item(%Scope{} = scope, %OrderItem{} = order_item, attrs) do
    true = order_item.user_id == scope.user.id

    with {:ok, order_item = %OrderItem{}} <-
           order_item
           |> OrderItem.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_order_item(scope, {:updated, order_item})
      {:ok, order_item}
    end
  end

  @doc """
  Deletes a order_item.

  ## Examples

      iex> delete_order_item(scope, order_item)
      {:ok, %OrderItem{}}

      iex> delete_order_item(scope, order_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_item(%Scope{} = scope, %OrderItem{} = order_item) do
    true = order_item.user_id == scope.user.id

    with {:ok, order_item = %OrderItem{}} <-
           Repo.delete(order_item) do
      broadcast_order_item(scope, {:deleted, order_item})
      {:ok, order_item}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_item changes.

  ## Examples

      iex> change_order_item(scope, order_item)
      %Ecto.Changeset{data: %OrderItem{}}

  """
  def change_order_item(%Scope{} = scope, %OrderItem{} = order_item, attrs \\ %{}) do
    true = order_item.user_id == scope.user.id

    OrderItem.changeset(order_item, attrs, scope)
  end
end
