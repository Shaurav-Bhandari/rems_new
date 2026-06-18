defmodule BinduBackend.Repo.TenantMigrations.CreatePaymentRecords do
  use Ecto.Migration

  def change do

    create table(:payment_records, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :amount, :decimal, null: false
      add :payment_method, :string, null: false
      add :provider, :string, null: false           # "fonepay", "esewa", "cash", "card"
      add :status, :string, null: false, default: "pending"
      add :transaction_id, :string
      add :payment_date, :utc_datetime, null: false

      # QR fields
      add :qr_image_data, :text
      add :qr_expires_at, :utc_datetime
      add :fonepay_transaction_id, :string
      add :verify_token, :string
      add :encoded_params, :text
      add :remarks, :string

      add :gateway_fee, :decimal, default: 0.0
      add :gateway_fee_percent, :decimal, default: 0.0

      # failure
      add :failure_reason, :text

      # provider specific extra fields
      add :metadata, :map, default: "{}"

      add :order_id, references(:orders, type: :uuid, on_delete: :restrict)
      add :user_id, references(:users, type: :uuid, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:payment_records, [:order_id])
    create index(:payment_records, [:user_id])
    create index(:payment_records, [:status])
    create index(:payment_records, [:provider])
    create index(:payment_records, [:payment_date])
    create index(:payment_records, [:verify_token])
    create index(:payment_records, [:fonepay_transaction_id])

    create table(:invoices, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :payment_record_id, references(:payment_records, type: :uuid, on_delete: :restrict)
      add :invoice_number, :string, null: false
      add :invoice_date, :date, null: false
      add :due_date, :date
      add :sub_total, :decimal, null: false
      add :tax, :decimal, default: 0.0
      add :discount_amount, :decimal, default: 0.0
      add :total_amount, :decimal, null: false
      add :status, :string, null: false, default: "unpaid"
      add :gateway_fee, :decimal, default: 0.0
      add :metadata, :map, default: "{}"

      add :order_id, references(:orders, type: :uuid, on_delete: :restrict)
      add :user_id, references(:users, type: :uuid, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end
    create unique_index(:invoices, [:invoice_number])
    create index(:invoices, [:order_id])
    create index(:invoices, [:payment_record_id])
    create index(:invoices, [:user_id])
    create index(:invoices, [:status])
    create index(:invoices, [:invoice_date])
    create index(:invoices, [:due_date])
  end
end

