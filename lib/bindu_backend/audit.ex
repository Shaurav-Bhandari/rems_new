defmodule BinduBackend.Audit do
  @moduledoc """
  The Audit context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Audit.AuditTrail

  @doc """
  Returns the list of audit_trails.

  ## Examples

      iex> list_audit_trails()
      [%AuditTrail{}, ...]

  """
  def list_audit_trails do
    Repo.all(AuditTrail)
  end

  @doc """
  Gets a single audit_trail.

  Raises `Ecto.NoResultsError` if the Audit trail does not exist.

  ## Examples

      iex> get_audit_trail!(123)
      %AuditTrail{}

      iex> get_audit_trail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_audit_trail!(id), do: Repo.get!(AuditTrail, id)

  @doc """
  Creates a audit_trail.

  ## Examples

      iex> create_audit_trail(%{field: value})
      {:ok, %AuditTrail{}}

      iex> create_audit_trail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_audit_trail(attrs) do
    %AuditTrail{}
    |> AuditTrail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a audit_trail.

  ## Examples

      iex> update_audit_trail(audit_trail, %{field: new_value})
      {:ok, %AuditTrail{}}

      iex> update_audit_trail(audit_trail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_audit_trail(%AuditTrail{} = audit_trail, attrs) do
    audit_trail
    |> AuditTrail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a audit_trail.

  ## Examples

      iex> delete_audit_trail(audit_trail)
      {:ok, %AuditTrail{}}

      iex> delete_audit_trail(audit_trail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_audit_trail(%AuditTrail{} = audit_trail) do
    Repo.delete(audit_trail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking audit_trail changes.

  ## Examples

      iex> change_audit_trail(audit_trail)
      %Ecto.Changeset{data: %AuditTrail{}}

  """
  def change_audit_trail(%AuditTrail{} = audit_trail, attrs \\ %{}) do
    AuditTrail.changeset(audit_trail, attrs)
  end

  alias BinduBackend.Audit.AnomalyRecord

  @doc """
  Returns the list of anomaly_records.

  ## Examples

      iex> list_anomaly_records()
      [%AnomalyRecord{}, ...]

  """
  def list_anomaly_records do
    Repo.all(AnomalyRecord)
  end

  @doc """
  Gets a single anomaly_record.

  Raises `Ecto.NoResultsError` if the Anomaly record does not exist.

  ## Examples

      iex> get_anomaly_record!(123)
      %AnomalyRecord{}

      iex> get_anomaly_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_anomaly_record!(id), do: Repo.get!(AnomalyRecord, id)

  @doc """
  Creates a anomaly_record.

  ## Examples

      iex> create_anomaly_record(%{field: value})
      {:ok, %AnomalyRecord{}}

      iex> create_anomaly_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_anomaly_record(attrs) do
    %AnomalyRecord{}
    |> AnomalyRecord.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a anomaly_record.

  ## Examples

      iex> update_anomaly_record(anomaly_record, %{field: new_value})
      {:ok, %AnomalyRecord{}}

      iex> update_anomaly_record(anomaly_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_anomaly_record(%AnomalyRecord{} = anomaly_record, attrs) do
    anomaly_record
    |> AnomalyRecord.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a anomaly_record.

  ## Examples

      iex> delete_anomaly_record(anomaly_record)
      {:ok, %AnomalyRecord{}}

      iex> delete_anomaly_record(anomaly_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_anomaly_record(%AnomalyRecord{} = anomaly_record) do
    Repo.delete(anomaly_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking anomaly_record changes.

  ## Examples

      iex> change_anomaly_record(anomaly_record)
      %Ecto.Changeset{data: %AnomalyRecord{}}

  """
  def change_anomaly_record(%AnomalyRecord{} = anomaly_record, attrs \\ %{}) do
    AnomalyRecord.changeset(anomaly_record, attrs)
  end
end
