defmodule BinduBackend.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :quantity, :integer, null: false
      add :unit_price, :float, null: false
      add :notes, :text
      add :status_id, references(:order_item_statuses, type: :uuid, on_delete: :restrict)
      add :menu_item_id, references(:menu_items, type: :uuid, on_delete: :restrict)
      add :order_id, references(:orders, type: :uuid, on_delete: :delete_all), null: false
      add :group_id, references(:order_groups, type: :uuid, on_delete: :delete_all)
      add :user_id, references(:users, type: :uuid, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:order_items, [:order_id])
    create index(:order_items, [:group_id])
    create index(:order_items, [:user_id])
    create index(:order_items, [:status_id])

    create table(:order_item_modifiers, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :added_price, :float, default: 0.0
      add :order_item_id, references(:order_items, type: :uuid, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:order_item_modifiers, [:order_item_id])
  end
end
