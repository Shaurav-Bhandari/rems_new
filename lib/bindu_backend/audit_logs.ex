defmodule BinduBackend.AuditLogs do
  @moduledoc """
  The AuditLogs context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.AuditLogs.AuditLog
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any audit_log changes.

  The broadcasted messages match the pattern:

    * {:created, %AuditLog{}}
    * {:updated, %AuditLog{}}
    * {:deleted, %AuditLog{}}

  """
  def subscribe_activity_log(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:activity_log")
  end

  defp broadcast_audit_log(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:activity_log", message)
  end

  @doc """
  Returns the list of activity_log.

  ## Examples

      iex> list_activity_log(scope)
      [%AuditLog{}, ...]

  """
  def list_activity_log(%Scope{} = scope) do
    Repo.all_by(AuditLog, user_id: scope.user.id)
  end

  @doc """
  Gets a single audit_log.

  Raises `Ecto.NoResultsError` if the Audit log does not exist.

  ## Examples

      iex> get_audit_log!(scope, 123)
      %AuditLog{}

      iex> get_audit_log!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_audit_log!(%Scope{} = scope, id) do
    Repo.get_by!(AuditLog, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a audit_log.

  ## Examples

      iex> create_audit_log(scope, %{field: value})
      {:ok, %AuditLog{}}

      iex> create_audit_log(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_audit_log(%Scope{} = scope, attrs) do
    with {:ok, audit_log = %AuditLog{}} <-
           %AuditLog{}
           |> AuditLog.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_audit_log(scope, {:created, audit_log})
      {:ok, audit_log}
    end
  end

  @doc """
  Updates a audit_log.

  ## Examples

      iex> update_audit_log(scope, audit_log, %{field: new_value})
      {:ok, %AuditLog{}}

      iex> update_audit_log(scope, audit_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_audit_log(%Scope{} = scope, %AuditLog{} = audit_log, attrs) do
    true = audit_log.user_id == scope.user.id

    with {:ok, audit_log = %AuditLog{}} <-
           audit_log
           |> AuditLog.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_audit_log(scope, {:updated, audit_log})
      {:ok, audit_log}
    end
  end

  @doc """
  Deletes a audit_log.

  ## Examples

      iex> delete_audit_log(scope, audit_log)
      {:ok, %AuditLog{}}

      iex> delete_audit_log(scope, audit_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_audit_log(%Scope{} = scope, %AuditLog{} = audit_log) do
    true = audit_log.user_id == scope.user.id

    with {:ok, audit_log = %AuditLog{}} <-
           Repo.delete(audit_log) do
      broadcast_audit_log(scope, {:deleted, audit_log})
      {:ok, audit_log}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking audit_log changes.

  ## Examples

      iex> change_audit_log(scope, audit_log)
      %Ecto.Changeset{data: %AuditLog{}}

  """
  def change_audit_log(%Scope{} = scope, %AuditLog{} = audit_log, attrs \\ %{}) do
    true = audit_log.user_id == scope.user.id

    AuditLog.changeset(audit_log, attrs, scope)
  end
end
