defmodule BinduBackend.Menus.Menu do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "menu_categories" do
    field :name, :string
    field :description, :string
    field :display_order, :integer
    field :is_active, :boolean, default: false
    field :category_image_url, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)

    has_many :menu_items, BinduBackend.Menu.MenuItem
  end

  @doc false
  def changeset(menu, attrs, user_scope) do
    menu
    |> cast(attrs, [:name, :description, :display_order, :is_active, :category_image_url])
    |> validate_required([:name, :description, :display_order, :is_active, :category_image_url])
    |> put_change(:user_id, user_scope.user.id)
  end
end
