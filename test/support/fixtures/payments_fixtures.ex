defmodule BinduBackend.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Payments` context.
  """

  @doc """
  Generate a payment_record.
  """
  def payment_record_fixture(attrs \\ %{}) do
    {:ok, payment_record} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        encoded_params: "some encoded_params",
        failure_reason: "some failure_reason",
        fonepay_transaction_id: "some fonepay_transaction_id",
        payment_date: ~U[2026-05-09 16:08:00Z],
        payment_method: "some payment_method",
        qr_expires_at: ~U[2026-05-09 16:08:00Z],
        qr_image_data: "some qr_image_data",
        status: "some status",
        transaction_id: "some transaction_id",
        verify_token: "some verify_token"
      })
      |> BinduBackend.Payments.create_payment_record()

    payment_record
  end
end
