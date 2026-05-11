defmodule BinduBackend.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :taken_by_id, references(:users, type: :uuid, on_delete: :restrict), null: false
      add :sub_total, :float
      add :service_charge, :float
      add :order_status, references(:order_item_statuses, type: :uuid, on_delete: :restrict)
      add :order_type, :text
      add :total_amount, :float
      add :notes, :text
      add :user_id, references(:users, on_delete: :restrict, type: :uuid), null: false
      add :table_id, references(:tables, on_delete: :restrict, type: :uuid), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:orders, [:user_id])
    create index(:orders, [:table_id])
    create index(:orders, [:taken_by_id])

    create table(:order_logs, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :order_id, references(:orders, type: :uuid, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :uuid, on_delete: :restrict), null: false
      add :action, :string, null: false
      add :change_type, :string
      add :previous_value, :text
      add :new_value, :text

      timestamps(type: :utc_datetime)
    end
  end
end
