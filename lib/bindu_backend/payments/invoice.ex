defmodule BinduBackend.Payments.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @valid_statuses ~w(unpaid paid partially_paid overdue cancelled refunded)

  schema "invoices" do
    field :invoice_number, :string
    field :invoice_date, :date
    field :due_date, :date
    field :sub_total, :decimal
    field :tax, :decimal, default: 0.0
    field :discount_amount, :decimal, default: 0.0
    field :gateway_fee, :decimal, default: 0.0
    field :total_amount, :decimal
    field :status, :string, default: "unpaid"
    field :metadata, :map, default: %{}

    belongs_to :order, BinduBackend.Orders.Order
    belongs_to :payment_record, BinduBackend.Payments.PaymentRecord
    belongs_to :user, BinduBackend.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :invoice_number,
      :invoice_date,
      :due_date,
      :sub_total,
      :tax,
      :discount_amount,
      :gateway_fee,
      :total_amount,
      :status,
      :metadata,
      :order_id,
      :payment_record_id,
      :user_id
    ])
    |> validate_required([:invoice_number, :invoice_date, :sub_total, :total_amount, :user_id])
    |> validate_number(:sub_total, greater_than_or_equal_to: 0)
    |> validate_number(:total_amount, greater_than_or_equal_to: 0)
    |> validate_number(:tax, greater_than_or_equal_to: 0)
    |> validate_number(:discount_amount, greater_than_or_equal_to: 0)
    |> validate_number(:gateway_fee, greater_than_or_equal_to: 0)
    |> validate_inclusion(:status, @valid_statuses)
    |> unique_constraint(:invoice_number)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:payment_record_id)
    |> foreign_key_constraint(:user_id)
  end

  def status_changeset(invoice, status) do
    invoice
    |> cast(%{status: status}, [:status])
    |> validate_inclusion(:status, @valid_statuses)
  end

  def total_amount(sub_total, tax, discount, gateway_fee) do
    Decimal.add(sub_total, tax)
    |> Decimal.sub(discount)
    |> Decimal.add(gateway_fee)
  end
end
