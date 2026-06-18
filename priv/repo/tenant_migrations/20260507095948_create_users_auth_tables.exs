defmodule BinduBackend.Repo.TenantMigrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do


    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :account_id, :uuid, null: true
      add :first_name, :string, null: true
      add :last_name, :string, null: true
      add :email, :citext, null: false
      add :contact_number, :string, null: true
      add :address, :string, null: true
      add :is_active, :boolean, default: true
      add :is_deleted, :boolean, default: false
      add :is_email_verified, :boolean, default: false, null: false

      add :deleted_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end


    create unique_index(:users, [:email])
    create index(:users, [:account_id])

    create table(:user_roles, primary_key: false) do
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      add :role_id, references(:roles, type: :uuid, on_delete: :delete_all), null: false
      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_roles, [:user_id, :role_id])
    create table(:sessions) do
      add :user_id,
          references(:users, type: :uuid, on_delete: :delete_all),
          null: false

      add :refresh_token_hash, :binary, null: false
      add :device_name, :string
      add :ip_address, :string
      add :user_agent, :text
      add :expires_at, :utc_datetime
      add :revoked_at, :utc_datetime
      add :last_used_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

create index(:sessions, [:user_id])
  end
end

