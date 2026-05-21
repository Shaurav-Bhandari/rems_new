defmodule BinduBackend.Repo.Migrations.CreateKots do
  use Ecto.Migration

  def change do
    create table(:kots, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :order_id, references(:orders, type: :uuid, on_delete: :delete_all), null: false
      add :kot_number, :text
      add :sequence_number, :integer
      add :order_number, :string
      add :customer_name, :text
      add :guest_count, :integer
      add :print_count, :integer
      add :user_id, references(:users, type: :uuid, on_delete: :restrict), null: false
      add :table_id, references(:restaurant_tables, type: :uuid, on_delete: :restrict), null: false
      add :status_id, references(:kot_statuses, type: :uuid, on_delete: :restrict), null: false
      add :kot_priority_id, references(:kot_priorities, type: :uuid, on_delete: :restrict), null: false
      add :order_type_id, references(:order_types, type: :uuid, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:kots, [:order_id])
    create index(:kots, [:user_id])
    create index(:kots, [:status_id])
    create index(:kots, [:kot_priority_id])
    create index(:kots, [:order_type_id])
    create index(:kots, [:table_id])

    create table(:kot_items, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :kot_id, references(:kots, type: :uuid, on_delete: :delete_all), null: false
      add :order_item_id, references(:order_items, type: :uuid, on_delete: :restrict), null: false
      add :item_name, :text, null: false
      add :quantity, :integer
      add :special_instructions, :text
      add :status_id, references(:kot_item_statuses, type: :uuid, on_delete: :restrict), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:kot_items, [:kot_id])
    create index(:kot_items, [:order_item_id])
    create index(:kot_items, [:status_id])
  end
end
