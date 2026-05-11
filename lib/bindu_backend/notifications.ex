defmodule BinduBackend.Notifications do
  @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Notifications.Notification
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any notification changes.

  The broadcasted messages match the pattern:

    * {:created, %Notification{}}
    * {:updated, %Notification{}}
    * {:deleted, %Notification{}}

  """
  def subscribe_notifications(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:notifications")
  end

  defp broadcast_notification(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:notifications", message)
  end

  @doc """
  Returns the list of notifications.

  ## Examples

      iex> list_notifications(scope)
      [%Notification{}, ...]

  """
  def list_notifications(%Scope{} = scope) do
    Repo.all_by(Notification, user_id: scope.user.id)
  end

  @doc """
  Gets a single notification.

  Raises `Ecto.NoResultsError` if the Notification does not exist.

  ## Examples

      iex> get_notification!(scope, 123)
      %Notification{}

      iex> get_notification!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_notification!(%Scope{} = scope, id) do
    Repo.get_by!(Notification, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a notification.

  ## Examples

      iex> create_notification(scope, %{field: value})
      {:ok, %Notification{}}

      iex> create_notification(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_notification(%Scope{} = scope, attrs) do
    with {:ok, notification = %Notification{}} <-
           %Notification{}
           |> Notification.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_notification(scope, {:created, notification})
      {:ok, notification}
    end
  end

  @doc """
  Updates a notification.

  ## Examples

      iex> update_notification(scope, notification, %{field: new_value})
      {:ok, %Notification{}}

      iex> update_notification(scope, notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_notification(%Scope{} = scope, %Notification{} = notification, attrs) do
    true = notification.user_id == scope.user.id

    with {:ok, notification = %Notification{}} <-
           notification
           |> Notification.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_notification(scope, {:updated, notification})
      {:ok, notification}
    end
  end

  @doc """
  Deletes a notification.

  ## Examples

      iex> delete_notification(scope, notification)
      {:ok, %Notification{}}

      iex> delete_notification(scope, notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_notification(%Scope{} = scope, %Notification{} = notification) do
    true = notification.user_id == scope.user.id

    with {:ok, notification = %Notification{}} <-
           Repo.delete(notification) do
      broadcast_notification(scope, {:deleted, notification})
      {:ok, notification}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking notification changes.

  ## Examples

      iex> change_notification(scope, notification)
      %Ecto.Changeset{data: %Notification{}}

  """
  def change_notification(%Scope{} = scope, %Notification{} = notification, attrs \\ %{}) do
    true = notification.user_id == scope.user.id

    Notification.changeset(notification, attrs, scope)
  end
end
