defmodule BinduBackend.Repo.Migrations.CreateAccountsAuthTables do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"", ""

    create_if_not_exists table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :email, :citext, null: false
      add :first_name, :string
      add :last_name, :string
      add :role, :string, null: false, default: "user"
      add :contact_number, :string
      add :address, :string
      add :hashed_password, :string
      add :is_active, :boolean, default: true, null: false
      add :is_deleted, :boolean, default: false, null: false
      add :is_email_verified, :boolean, default: false, null: false
      add :failed_login_attempts, :integer, default: 0, null: false
      add :locked_until, :utc_datetime
      add :confirmed_at, :utc_datetime
      add :deleted_at, :utc_datetime
      add :last_login_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create_if_not_exists unique_index(:accounts, [:email])
    create_if_not_exists index(:accounts, [:role])
    create_if_not_exists index(:accounts, [:is_active])

    create_if_not_exists table(:accounts_tokens) do
      add :account_id, references(:accounts, type: :uuid, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :authenticated_at, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create_if_not_exists index(:accounts_tokens, [:account_id])
    create_if_not_exists unique_index(:accounts_tokens, [:context, :token])

    execute """
            INSERT INTO accounts (
              id, email, first_name, last_name, role, hashed_password, is_active,
              confirmed_at, last_login_at, inserted_at, updated_at
            )
            SELECT
              id, email, first_name, last_name, 'super_admin', hashed_password,
              COALESCE(is_active, true), confirmed_at, last_login_at, inserted_at, updated_at
            FROM super_admins
            ON CONFLICT (email) DO NOTHING
            """,
            ""

    alter table(:tenants) do
      add_if_not_exists :owner_account_id,
                        references(:accounts, type: :uuid, on_delete: :nilify_all)
    end

    create_if_not_exists index(:tenants, [:owner_account_id])

    alter table(:tenant_onboarding) do
      add_if_not_exists :account_id, references(:accounts, type: :uuid, on_delete: :nilify_all)
    end

    create_if_not_exists index(:tenant_onboarding, [:account_id])

    drop_if_exists table(:super_admins_tokens)
    drop_if_exists table(:super_admins)
  end

  def down do
    create_if_not_exists table(:super_admins, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :email, :citext, null: false
      add :first_name, :string
      add :last_name, :string
      add :is_active, :boolean, default: true
      add :hashed_password, :string
      add :confirmed_at, :utc_datetime
      add :last_login_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create_if_not_exists unique_index(:super_admins, [:email])

    execute """
            INSERT INTO super_admins (
              id, email, first_name, last_name, is_active, hashed_password,
              confirmed_at, last_login_at, inserted_at, updated_at
            )
            SELECT
              id, email, first_name, last_name, is_active, hashed_password,
              confirmed_at, last_login_at, inserted_at, updated_at
            FROM accounts
            WHERE role = 'super_admin'
            ON CONFLICT (email) DO NOTHING
            """,
            ""

    alter table(:tenant_onboarding) do
      remove_if_exists :account_id, references(:accounts, type: :uuid)
    end

    alter table(:tenants) do
      remove_if_exists :owner_account_id, references(:accounts, type: :uuid)
    end

    drop_if_exists table(:accounts_tokens)
    drop_if_exists table(:accounts)
  end
end
