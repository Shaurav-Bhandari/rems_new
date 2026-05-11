defmodule BinduBackend.Seatings do
  @moduledoc """
  The Seatings context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Seatings.Floor
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any floor changes.

  The broadcasted messages match the pattern:

    * {:created, %Floor{}}
    * {:updated, %Floor{}}
    * {:deleted, %Floor{}}

  """
  def subscribe_floors(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:floors")
  end

  defp broadcast_floor(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:floors", message)
  end

  @doc """
  Returns the list of floors.

  ## Examples

      iex> list_floors(scope)
      [%Floor{}, ...]

  """
  def list_floors(%Scope{} = scope) do
    Repo.all_by(Floor, user_id: scope.user.id)
  end

  @doc """
  Gets a single floor.

  Raises `Ecto.NoResultsError` if the Floor does not exist.

  ## Examples

      iex> get_floor!(scope, 123)
      %Floor{}

      iex> get_floor!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_floor!(%Scope{} = scope, id) do
    Repo.get_by!(Floor, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a floor.

  ## Examples

      iex> create_floor(scope, %{field: value})
      {:ok, %Floor{}}

      iex> create_floor(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_floor(%Scope{} = scope, attrs) do
    with {:ok, floor = %Floor{}} <-
           %Floor{}
           |> Floor.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_floor(scope, {:created, floor})
      {:ok, floor}
    end
  end

  @doc """
  Updates a floor.

  ## Examples

      iex> update_floor(scope, floor, %{field: new_value})
      {:ok, %Floor{}}

      iex> update_floor(scope, floor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_floor(%Scope{} = scope, %Floor{} = floor, attrs) do
    true = floor.user_id == scope.user.id

    with {:ok, floor = %Floor{}} <-
           floor
           |> Floor.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_floor(scope, {:updated, floor})
      {:ok, floor}
    end
  end

  @doc """
  Deletes a floor.

  ## Examples

      iex> delete_floor(scope, floor)
      {:ok, %Floor{}}

      iex> delete_floor(scope, floor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_floor(%Scope{} = scope, %Floor{} = floor) do
    true = floor.user_id == scope.user.id

    with {:ok, floor = %Floor{}} <-
           Repo.delete(floor) do
      broadcast_floor(scope, {:deleted, floor})
      {:ok, floor}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking floor changes.

  ## Examples

      iex> change_floor(scope, floor)
      %Ecto.Changeset{data: %Floor{}}

  """
  def change_floor(%Scope{} = scope, %Floor{} = floor, attrs \\ %{}) do
    true = floor.user_id == scope.user.id

    Floor.changeset(floor, attrs, scope)
  end
end
