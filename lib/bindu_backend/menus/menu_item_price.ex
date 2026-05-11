defmodule BinduBackend.Menus.MenuItemPrice do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "menu_item_prices" do
    field :price_type, :string
    field :price, :decimal

    belongs_to :menu_item, BinduBackend.Menus.MenuItem
    belongs_to :order_type, BinduBackend.Flags.OrderType, foreign_key: :order_type_id

    timestamps(type: :utc_datetime)
  end

  def changeset(price, attrs) do
    price
    |> cast(attrs, [:price_type, :price, :menu_item_id, :order_type_id])
    |> validate_required([:price, :menu_item_id])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:menu_item_id)
    |> foreign_key_constraint(:order_type_id)
  end
end
