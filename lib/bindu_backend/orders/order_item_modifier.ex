defmodule BinduBackend.Orders.OrderItemModifier do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "order_item_modifiers" do
    field :name, :string
    field :added_price, :float, default: 0.0

    belongs_to :order_item, BinduBackend.Orders.OrderItem

    timestamps(type: :utc_datetime)
  end

  def changeset(modifier, attrs) do
    modifier
    |> cast(attrs, [:name, :added_price, :order_item_id])
    |> validate_required([:name, :order_item_id])
    |> validate_number(:added_price, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:order_item_id)
  end
end
