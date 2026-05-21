defmodule BinduBackend.AuditLogs do
  @moduledoc """
  The AuditLogs context.
  """

  import Ecto.Query, warn: false

  alias BinduBackend.Repo
  alias BinduBackend.Audit.ActivityLog
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any activity log changes.

  Broadcasted messages:

    * {:created, %ActivityLog{}}
    * {:updated, %ActivityLog{}}
    * {:deleted, %ActivityLog{}}
  """
  def subscribe_activity_log(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(
      BinduBackend.PubSub,
      "user:#{key}:activity_log"
    )
  end

  defp broadcast_activity_log(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(
      BinduBackend.PubSub,
      "user:#{key}:activity_log",
      message
    )
  end

  @doc """
  Returns all activity logs for the current scoped user.
  """
  def list_activity_logs(%Scope{} = scope) do
    Repo.all(
      from a in ActivityLog,
        where: a.user_id == ^scope.user.id,
        order_by: [desc: a.inserted_at]
    )
  end

  @doc """
  Gets a single activity log.

  Raises `Ecto.NoResultsError` if not found.
  """
  def get_activity_log!(%Scope{} = scope, id) do
    Repo.get_by!(
      ActivityLog,
      id: id,
      user_id: scope.user.id
    )
  end

  @doc """
  Creates an activity log.
  """
  def create_activity_log(%Scope{} = scope, attrs) do
    attrs =
      Map.put(attrs, :user_id, scope.user.id)

    with {:ok, activity_log = %ActivityLog{}} <-
           %ActivityLog{}
           |> ActivityLog.changeset(attrs)
           |> Repo.insert() do
      broadcast_activity_log(
        scope,
        {:created, activity_log}
      )

      {:ok, activity_log}
    end
  end

  @doc """
  Updates an activity log.
  """
  def update_activity_log(
        %Scope{} = scope,
        %ActivityLog{} = activity_log,
        attrs
      ) do
    true = activity_log.user_id == scope.user.id

    with {:ok, activity_log = %ActivityLog{}} <-
           activity_log
           |> ActivityLog.changeset(attrs)
           |> Repo.update() do
      broadcast_activity_log(
        scope,
        {:updated, activity_log}
      )

      {:ok, activity_log}
    end
  end

  @doc """
  Deletes an activity log.
  """
  def delete_activity_log(
        %Scope{} = scope,
        %ActivityLog{} = activity_log
      ) do
    true = activity_log.user_id == scope.user.id

    with {:ok, activity_log = %ActivityLog{}} <-
           Repo.delete(activity_log) do
      broadcast_activity_log(
        scope,
        {:deleted, activity_log}
      )

      {:ok, activity_log}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking activity log changes.
  """
  def change_activity_log(
        %Scope{} = scope,
        %ActivityLog{} = activity_log,
        attrs \\ %{}
      ) do
    true = activity_log.user_id == scope.user.id

    ActivityLog.changeset(activity_log, attrs)
  end
end
