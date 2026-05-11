defmodule BinduBackend.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do


    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :citext, null: false
      add :contact_number, :string, null: false
      add :address, :string, null: false
      add :hashed_password, :string
      add :is_active, :boolean, default: true
      add :is_deleted, :boolean, default: false
      add :is_email_verified, :boolean, default: false, null: false

      add :failed_login_attempts, :integer, default: 0
      add :locked_until, :utc_datetime
      add :confirmed_at, :utc_datetime
      add :deleted_at, :utc_datetime
      timestamps(type: :utc_datetime)
    end


    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :authenticated_at, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

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
