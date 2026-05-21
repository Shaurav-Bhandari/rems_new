defmodule BinduBackend.Orders.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "order_items" do
    field :quantity, :integer
    field :unit_price, :float
    field :notes, :string

    belongs_to :status, BinduBackend.Flags.OrderItemStatus
    belongs_to :order, BinduBackend.Orders.Order
    belongs_to :group, BinduBackend.Orders.OrderGroup
    belongs_to :user, BinduBackend.Accounts.User
    belongs_to :menu_item, BinduBackend.Menus.MenuItem

    has_many :modifiers, BinduBackend.Orders.OrderItemModifier

    timestamps(type: :utc_datetime)
  end

  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [
      :quantity,
      :unit_price,
      :notes,
      :status_id,
      :order_id,
      :group_id,
      :user_id,
      :menu_item_id
    ])
    |> validate_required([:quantity, :unit_price, :order_id, :user_id])
    |> validate_number(:quantity, greater_than: 0)
    |> validate_number(:unit_price, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:status_id)
    |> foreign_key_constraint(:menu_item_id)
  end

  def changeset(order_item, attrs, user_scope) do
    order_item
    |> cast(attrs, [
      :quantity,
      :unit_price,
      :notes,
      :status_id,
      :order_id,
      :group_id,
      :menu_item_id
    ])
    |> validate_required([:quantity, :unit_price, :order_id])
    |> put_change(:user_id, user_scope.user.id)
    |> validate_number(:quantity, greater_than: 0)
    |> validate_number(:unit_price, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:status_id)
    |> foreign_key_constraint(:menu_item_id)
  end
end
