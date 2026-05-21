defmodule BinduBackend.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "orders" do
    field :sub_total, :float
    field :service_charge, :float
    field :order_status, :string
    field :order_type, :string
    field :total_amount, :float
    field :notes, :string
    timestamps(type: :utc_datetime)

    belongs_to :table, BinduBackend.Restaurant.RestaurantTable
    belongs_to :user, BinduBackend.Accounts.User, type: Ecto.UUID

    has_many :order_groups, BinduBackend.Orders.OrderGroup
    has_many :order_items, BinduBackend.Orders.OrderItem
    has_many :payment_records, BinduBackend.Payments.PaymentRecord

    has_one :invoice, BinduBackend.Payments.Invoice
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :sub_total,
      :service_charge,
      :order_status,
      :order_type,
      :total_amount,
      :notes,
      :user_id,
      :taken_by_id,
      :table_id
    ])
    |> validate_required([
      :sub_total,
      :service_charge,
      :order_status,
      :order_type,
      :total_amount,
      :user_id,
      :taken_by_id
    ])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:taken_by_id)
    |> foreign_key_constraint(:table_id)
  end
end
