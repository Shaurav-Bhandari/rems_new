defmodule BinduBackend.Payments.PaymentRecord do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @valid_statuses ~w(pending pending_qr awaiting_confirm confirmed failed refunded)
  @valid_providers ~w(fonepay esewa cash card)

  schema "payment_records" do
    field :amount, :decimal
    field :payment_method, :string
    field :provider, :string
    field :status, :string, default: "pending"
    field :transaction_id, :string
    field :payment_date, :utc_datetime

    # QR fields
    field :qr_image_data, :string
    field :qr_expires_at, :utc_datetime
    field :fonepay_transaction_id, :string
    field :verify_token, :string
    field :encoded_params, :string
    field :remarks, :string

    field :gateway_fee, :decimal, default: 0.0
    field :gateway_fee_percent, :decimal, default: 0.0

    # failure
    field :failure_reason, :string

    # provider specific
    field :metadata, :map, default: %{}

    belongs_to :order, BinduBackend.Orders.Order
    belongs_to :user, BinduBackend.Accounts.User

    has_one :invoice, BinduBackend.Payments.Invoice

    timestamps(type: :utc_datetime)
  end

  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :amount,
      :payment_method,
      :provider,
      :status,
      :transaction_id,
      :payment_date,
      :qr_image_data,
      :qr_expires_at,
      :fonepay_transaction_id,
      :verify_token,
      :encoded_params,
      :remarks,
      :failure_reason,
      :metadata,
      :order_id,
      :user_id
    ])
    |> validate_required([:amount, :payment_method, :provider, :payment_date, :user_id])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:provider, @valid_providers)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:user_id)
  end

  def qr_changeset(payment, attrs) do
    payment
    |> cast(attrs, [:qr_image_data, :qr_expires_at, :fonepay_transaction_id, :verify_token])
    |> validate_required([:qr_image_data, :qr_expires_at, :fonepay_transaction_id, :verify_token])
  end

  def status_changeset(payment, status, reason \\ nil) do
    payment
    |> cast(%{status: status, failure_reason: reason}, [:status, :failure_reason])
    |> validate_inclusion(:status, @valid_statuses)
  end

  def confirm_changeset(payment, transaction_id) do
    now = DateTime.utc_now(:second)

    cast(
      payment,
      %{
        status: "confirmed",
        transaction_id: transaction_id,
        payment_date: now
      },
      [:status, :transaction_id, :payment_date]
    )
  end

  def qr_expired?(%__MODULE__{qr_expires_at: nil}), do: false

  def qr_expired?(%__MODULE__{qr_expires_at: expires_at}) do
    DateTime.compare(DateTime.utc_now(), expires_at) == :gt
  end
end
