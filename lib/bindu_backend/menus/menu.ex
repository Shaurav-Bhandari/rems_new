defmodule BinduBackend.Menus.Menu do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "menu_categories" do
    field :name, :string
    field :description, :string
    field :display_order, :integer
    field :is_active, :boolean, default: true
    field :category_image_url, :string
    field :user_id, :id

    has_many :menu_items, BinduBackend.Menus.MenuItem, foreign_key: :category_id

    timestamps(type: :utc_datetime)
  end

  def changeset(menu, attrs, user_scope) do
    menu
    |> cast(attrs, [:name, :description, :display_order, :is_active, :category_image_url])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> put_change(:user_id, user_scope.user.id)
  end
end
