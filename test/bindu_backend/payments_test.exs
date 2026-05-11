defmodule BinduBackend.PaymentsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Payments

  describe "payment_records" do
    alias BinduBackend.Payments.PaymentRecord

    import BinduBackend.PaymentsFixtures

    @invalid_attrs %{status: nil, amount: nil, payment_method: nil, transaction_id: nil, payment_date: nil, qr_image_data: nil, qr_expires_at: nil, fonepay_transaction_id: nil, verify_token: nil, encoded_params: nil, failure_reason: nil}

    test "list_payment_records/0 returns all payment_records" do
      payment_record = payment_record_fixture()
      assert Payments.list_payment_records() == [payment_record]
    end

    test "get_payment_record!/1 returns the payment_record with given id" do
      payment_record = payment_record_fixture()
      assert Payments.get_payment_record!(payment_record.id) == payment_record
    end

    test "create_payment_record/1 with valid data creates a payment_record" do
      valid_attrs = %{status: "some status", amount: "120.5", payment_method: "some payment_method", transaction_id: "some transaction_id", payment_date: ~U[2026-05-09 16:08:00Z], qr_image_data: "some qr_image_data", qr_expires_at: ~U[2026-05-09 16:08:00Z], fonepay_transaction_id: "some fonepay_transaction_id", verify_token: "some verify_token", encoded_params: "some encoded_params", failure_reason: "some failure_reason"}

      assert {:ok, %PaymentRecord{} = payment_record} = Payments.create_payment_record(valid_attrs)
      assert payment_record.status == "some status"
      assert payment_record.amount == Decimal.new("120.5")
      assert payment_record.payment_method == "some payment_method"
      assert payment_record.transaction_id == "some transaction_id"
      assert payment_record.payment_date == ~U[2026-05-09 16:08:00Z]
      assert payment_record.qr_image_data == "some qr_image_data"
      assert payment_record.qr_expires_at == ~U[2026-05-09 16:08:00Z]
      assert payment_record.fonepay_transaction_id == "some fonepay_transaction_id"
      assert payment_record.verify_token == "some verify_token"
      assert payment_record.encoded_params == "some encoded_params"
      assert payment_record.failure_reason == "some failure_reason"
    end

    test "create_payment_record/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment_record(@invalid_attrs)
    end

    test "update_payment_record/2 with valid data updates the payment_record" do
      payment_record = payment_record_fixture()
      update_attrs = %{status: "some updated status", amount: "456.7", payment_method: "some updated payment_method", transaction_id: "some updated transaction_id", payment_date: ~U[2026-05-10 16:08:00Z], qr_image_data: "some updated qr_image_data", qr_expires_at: ~U[2026-05-10 16:08:00Z], fonepay_transaction_id: "some updated fonepay_transaction_id", verify_token: "some updated verify_token", encoded_params: "some updated encoded_params", failure_reason: "some updated failure_reason"}

      assert {:ok, %PaymentRecord{} = payment_record} = Payments.update_payment_record(payment_record, update_attrs)
      assert payment_record.status == "some updated status"
      assert payment_record.amount == Decimal.new("456.7")
      assert payment_record.payment_method == "some updated payment_method"
      assert payment_record.transaction_id == "some updated transaction_id"
      assert payment_record.payment_date == ~U[2026-05-10 16:08:00Z]
      assert payment_record.qr_image_data == "some updated qr_image_data"
      assert payment_record.qr_expires_at == ~U[2026-05-10 16:08:00Z]
      assert payment_record.fonepay_transaction_id == "some updated fonepay_transaction_id"
      assert payment_record.verify_token == "some updated verify_token"
      assert payment_record.encoded_params == "some updated encoded_params"
      assert payment_record.failure_reason == "some updated failure_reason"
    end

    test "update_payment_record/2 with invalid data returns error changeset" do
      payment_record = payment_record_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment_record(payment_record, @invalid_attrs)
      assert payment_record == Payments.get_payment_record!(payment_record.id)
    end

    test "delete_payment_record/1 deletes the payment_record" do
      payment_record = payment_record_fixture()
      assert {:ok, %PaymentRecord{}} = Payments.delete_payment_record(payment_record)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment_record!(payment_record.id) end
    end

    test "change_payment_record/1 returns a payment_record changeset" do
      payment_record = payment_record_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment_record(payment_record)
    end
  end
end
