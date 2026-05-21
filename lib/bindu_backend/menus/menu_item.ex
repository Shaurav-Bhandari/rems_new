defmodule BinduBackend.Menus.MenuItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "menu_items" do
    field :name, :string
    field :description, :string
    field :base_price, :decimal
    field :is_available, :boolean, default: true
    field :item_image_url, :string
    field :estimated_prep_time, :integer
    field :allergen_info, :string
    field :dietary_flags, :map, default: %{}
    field :user_id, :id

    belongs_to :menu_category, BinduBackend.Menus.Menu, foreign_key: :category_id
    has_many :modifiers, BinduBackend.Menus.MenuItemModifier
    has_many :prices, BinduBackend.Menus.MenuItemPrice

    timestamps(type: :utc_datetime)
  end

  def changeset(menu_item, attrs) do
    menu_item
    |> cast(attrs, [
      :name,
      :description,
      :base_price,
      :is_available,
      :item_image_url,
      :estimated_prep_time,
      :allergen_info,
      :dietary_flags,
      :category_id
    ])
    |> validate_required([:name, :base_price, :category_id])
    |> validate_number(:base_price, greater_than_or_equal_to: 0)
    |> foreign_key_constraint(:category_id)
  end
end
