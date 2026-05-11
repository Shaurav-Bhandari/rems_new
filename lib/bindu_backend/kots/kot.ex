# lib/bindu_backend/kot/kot.ex
defmodule BinduBackend.Kot.Kot do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "kots" do
    field :kot_number, :string
    field :sequence_number, :integer
    field :order_number, :string
    field :customer_name, :string
    field :guest_count, :integer
    field :print_count, :integer, default: 0

    belongs_to :order, BinduBackend.Orders.Order
    belongs_to :table, BinduBackend.Restaurant.RestaurantTable
    belongs_to :user, BinduBackend.Accounts.User
    belongs_to :status, BinduBackend.Flags.KotStatus, foreign_key: :status_id
    belongs_to :kot_priority, BinduBackend.Flags.KotPriority, foreign_key: :kot_priority_id
    belongs_to :order_type, BinduBackend.Flags.OrderType, foreign_key: :order_type_id

    has_many :kot_items, BinduBackend.Kot.KotItem

    timestamps(type: :utc_datetime)
  end

  def changeset(kot, attrs) do
    kot
    |> cast(attrs, [
      :kot_number, :sequence_number, :order_number,
      :customer_name, :guest_count, :print_count,
      :order_id, :table_id, :user_id,
      :status_id, :kot_priority_id, :order_type_id
    ])
    |> validate_required([:order_id, :table_id, :user_id, :status_id, :kot_priority_id, :order_type_id])
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:table_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:status_id)
    |> foreign_key_constraint(:kot_priority_id)
    |> foreign_key_constraint(:order_type_id)
  end
end
