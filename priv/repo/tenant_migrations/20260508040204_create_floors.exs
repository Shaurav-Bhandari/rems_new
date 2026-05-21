defmodule BinduBackend.Repo.Migrations.CreateFloors do
  use Ecto.Migration

  def change do
    create table(:floors, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :text, null: false
      add :code, :text
      add :description, :text
      add :display_order, :integer
      add :user_id, references(:users, type: :uuid, on_delete: :restrict)
      timestamps(type: :utc_datetime)
    end

    create index(:floors, [:user_id])
    create index(:floors, [:display_order])

    create table(:areas, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :text, null: false
      add :code, :text
      add :description, :text
      add :display_order, :integer
      add :floor_id, references(:floors, type: :uuid, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:areas, [:floor_id])
    create index(:areas, [:display_order])

    create table(:restaurant_tables, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :table_number, :integer, null: false
      add :capacity, :integer, null: false, default: 0
      add :table_shape, :text, default: "rectangle"
      add :status_id, references(:table_statuses, type: :uuid, on_delete: :nothing), null: false
      add :display_order, :integer
      add :is_mergeable, :boolean, default: false
      add :area_id, references(:areas, type: :uuid, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:restaurant_tables, [:area_id])
    create index(:restaurant_tables, [:status_id])
    create unique_index(:restaurant_tables, [:area_id, :table_number])

    create table(:table_groups, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :text, null: false, default: ""
      timestamps(type: :utc_datetime)
    end

    create unique_index(:table_groups, [:name])

    create table(:table_group_items, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :table_group_id, references(:table_groups, type: :uuid, on_delete: :delete_all), null: false
      add :restaurant_table_id, references(:restaurant_tables, type: :uuid, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:table_group_items, [:table_group_id])
    create index(:table_group_items, [:restaurant_table_id])
    create unique_index(:table_group_items, [:table_group_id, :restaurant_table_id])

    create table(:table_reservations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :customer_name, :text
      add :customer_contact, :text
      add :reservation_time, :utc_datetime, null: false
      add :number_of_people, :integer
      add :notes, :text
      add :status_id, references(:table_statuses, type: :uuid, on_delete: :nothing), null: false
      add :restaurant_table_id, references(:restaurant_tables, type: :uuid, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create index(:table_reservations, [:restaurant_table_id])
    create index(:table_reservations, [:status_id])
    create index(:table_reservations, [:reservation_time])
  end
end
