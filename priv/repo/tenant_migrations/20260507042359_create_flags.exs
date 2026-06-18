defmodule BinduBackend.Repo.TenantMigrations.TableStatus do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"", ""

    create table(:table_statuses, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_default, :boolean, default: false
      add :is_system, :boolean, default: false   # system = cannot be deleted
      add :is_active, :boolean, default: true
      add :position, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:table_statuses, [:name])

    create table(:order_types, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_default, :boolean, default: false
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :position, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:order_types, [:name])

    create table(:order_item_statuses, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_default, :boolean, default: false
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :position, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:order_item_statuses, [:name])

    create table(:kot_statuses, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_default, :boolean, default: false
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :position, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:kot_statuses, [:name])

    create table(:kot_priorities, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_default, :boolean, default: false
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :level, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:kot_priorities, [:name])

    create table(:kitchen_stations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_default, :boolean, default: false
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :position, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:kitchen_stations, [:name])

    create table(:notification_types, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:notification_types, [:name])

    create table(:rule_types, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:rule_types, [:name])

    create table(:audit_events, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:audit_events, [:name])

    create table(:reservation_statuses, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :position, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:reservation_statuses, [:name])

    create table(:kot_item_statuses, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :position, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:kot_item_statuses, [:name])
    

    create table(:rate_types, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:rate_types, [:name])

    create table(:audit_severities, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :label, :string
      add :description, :string
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      add :level, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:audit_severities, [:name])

    alter table(:table_statuses) do
      add :color, :string, null: true, comment: "Hex color code e.g. #22c55e"
    end

    alter table(:order_item_statuses) do
      add :color, :string, null: true
    end

    alter table(:kot_statuses) do
      add :color, :string, null: true
    end

    alter table(:kot_priorities) do
      add :color, :string, null: true
    end

    alter table(:reservation_statuses) do
      add :color, :string, null: true
    end
  end
end
