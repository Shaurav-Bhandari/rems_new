defmodule BinduBackend.Menus.MenuItemModifier do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "menu_item_modifier" do
    field :name, :string
    field :price_adjustment, :decimal, default: 0.0
    field :is_available, :boolean, default: true

    belongs_to :menu_item, BinduBackend.Menus.MenuItem

    timestamps(type: :utc_datetime)
  end

  def changeset(modifier, attrs) do
    modifier
    |> cast(attrs, [:name, :price_adjustment, :is_available, :menu_item_id])
    |> validate_required([:name, :menu_item_id])
    |> validate_number(:price_adjustment, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:menu_item_id)
  end
end
