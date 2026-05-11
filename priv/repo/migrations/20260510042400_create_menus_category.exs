defmodule BinduBackend.Repo.Migrations.CreateMenuCategory do
  use Ecto.Migration

  def change do
    create table(:menu_categories, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :text
      add :description, :text
      add :display_order, :integer
      add :is_active, :boolean, default: true, null: false
      add :category_image_url, :text

      timestamps(type: :utc_datetime)
    end


    create table(:menu_items, primary_key: false) do
    add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
    add :category_id, references(:menu_categories, type: :uuid, on_delete: :restrict), null: false
    add :name, :text, null: false
    add :description, :text
    add :base_price, :decimal, null: false, default: 0.0
    add :is_available, :boolean, default: true, null: false
    add :item_image_url, :text
    add :estimated_prep_time, :integer
    add :allergen_info, :text
    add :dietary_flags, :map, default: %{}

    timestamps(type: :utc_datetime)
    end

    create index(:menu_items, [:category_id])

    create table(:menu_item_modifier, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :menu_item_id, references(:menu_items, type: :uuid, on_delete: :restrict), null: false
      add :name, :text, null: false
      add :price_adjustment, :decimal, default: 0.0
      add :is_available, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end
    create index(:menu_item_modifiers, [:menu_item_id])

    create table(:menu_item_prices, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :menu_item_id, references(:menu_items, type: :uuid, on_delete: :restrict), null: false
      add :price_type, :text, null: false
      add :price, :decimal, null: false, default: 0.0

      timestamps(type: :utc_datetime)
    end

     create index(:menu_item_prices, [:menu_item_id])
  end
end
