defmodule BinduBackend.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Payments.PaymentRecord

  @doc """
  Returns the list of payment_records.

  ## Examples

      iex> list_payment_records()
      [%PaymentRecord{}, ...]

  """
  def list_payment_records do
    Repo.all(PaymentRecord)
  end

  @doc """
  Gets a single payment_record.

  Raises `Ecto.NoResultsError` if the Payment record does not exist.

  ## Examples

      iex> get_payment_record!(123)
      %PaymentRecord{}

      iex> get_payment_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_record!(id), do: Repo.get!(PaymentRecord, id)

  @doc """
  Creates a payment_record.

  ## Examples

      iex> create_payment_record(%{field: value})
      {:ok, %PaymentRecord{}}

      iex> create_payment_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_record(attrs) do
    %PaymentRecord{}
    |> PaymentRecord.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_record.

  ## Examples

      iex> update_payment_record(payment_record, %{field: new_value})
      {:ok, %PaymentRecord{}}

      iex> update_payment_record(payment_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_record(%PaymentRecord{} = payment_record, attrs) do
    payment_record
    |> PaymentRecord.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payment_record.

  ## Examples

      iex> delete_payment_record(payment_record)
      {:ok, %PaymentRecord{}}

      iex> delete_payment_record(payment_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_record(%PaymentRecord{} = payment_record) do
    Repo.delete(payment_record)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_record changes.

  ## Examples

      iex> change_payment_record(payment_record)
      %Ecto.Changeset{data: %PaymentRecord{}}

  """
  def change_payment_record(%PaymentRecord{} = payment_record, attrs \\ %{}) do
    PaymentRecord.changeset(payment_record, attrs)
  end
end
