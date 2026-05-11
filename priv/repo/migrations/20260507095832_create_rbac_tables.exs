defmodule BinduBackend.Repo.Migrations.CreateRbacTables do
  use Ecto.Migration

  def change do

    create table(:roles, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :role_name, :string, null: false
      add :description, :string
      add :is_deleted, :boolean, default: false
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create table(:permissions, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :permission_name, :string, null: false
      add :description, :string
      add :is_deleted, :boolean, default: false
      add :is_system, :boolean, default: true
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create table(:role_permissions, primary_key: false) do
      add :role_id, references(:roles, type: :uuid, on_delete: :delete_all), null: false
      add :permission_id, references(:permissions, type: :uuid, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end


    create unique_index(:role_permissions, [:role_id, :permission_id])
  end
end
