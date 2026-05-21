defmodule BinduBackend.Kots do
  @moduledoc """
  The Kots context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Kot.Kot
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any kot changes.

  The broadcasted messages match the pattern:

    * {:created, %Kot{}}
    * {:updated, %Kot{}}
    * {:deleted, %Kot{}}

  """
  def subscribe_kots(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:kots")
  end

  defp broadcast_kot(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:kots", message)
  end

  @doc """
  Returns the list of kots.

  ## Examples

      iex> list_kots(scope)
      [%Kot{}, ...]

  """
  def list_kots(%Scope{} = scope) do
    Repo.all_by(Kot, user_id: scope.user.id)
  end

  @doc """
  Gets a single kot.

  Raises `Ecto.NoResultsError` if the Kot does not exist.

  ## Examples

      iex> get_kot!(scope, 123)
      %Kot{}

      iex> get_kot!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_kot!(%Scope{} = scope, id) do
    Repo.get_by!(Kot, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a kot.

  ## Examples

      iex> create_kot(scope, %{field: value})
      {:ok, %Kot{}}

      iex> create_kot(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_kot(%Scope{} = scope, attrs) do
    with {:ok, kot = %Kot{}} <-
           %Kot{}
           |> Kot.changeset(attrs)
           |> Repo.insert() do
      broadcast_kot(scope, {:created, kot})
      {:ok, kot}
    end
  end

  @doc """
  Updates a kot.

  ## Examples

      iex> update_kot(scope, kot, %{field: new_value})
      {:ok, %Kot{}}

      iex> update_kot(scope, kot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_kot(%Scope{} = scope, %Kot{} = kot, attrs) do
    true = kot.user_id == scope.user.id

    with {:ok, kot = %Kot{}} <-
           kot
           |> Kot.changeset(attrs)
           |> Repo.update() do
      broadcast_kot(scope, {:updated, kot})
      {:ok, kot}
    end
  end

  @doc """
  Deletes a kot.

  ## Examples

      iex> delete_kot(scope, kot)
      {:ok, %Kot{}}

      iex> delete_kot(scope, kot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_kot(%Scope{} = scope, %Kot{} = kot) do
    true = kot.user_id == scope.user.id

    with {:ok, kot = %Kot{}} <-
           Repo.delete(kot) do
      broadcast_kot(scope, {:deleted, kot})
      {:ok, kot}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking kot changes.

  ## Examples

      iex> change_kot(scope, kot)
      %Ecto.Changeset{data: %Kot{}}

  """
  def change_kot(%Scope{} = scope, %Kot{} = kot, attrs \\ %{}) do
    true = kot.user_id == scope.user.id

    Kot.changeset(kot, attrs)
  end
end
