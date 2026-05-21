defmodule BinduBackend.Repo.Migrations.CreateSuperAdminsAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:super_admins, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :email, :citext, null: false
      add :first_name, :string
      add :last_name, :string
      add :is_active, :boolean, default: true

      add :hashed_password, :string
      add :confirmed_at, :utc_datetime
      add :last_login_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:super_admins, [:email])

    create table(:super_admins_tokens) do
      add :super_admin_id, references(:super_admins, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :authenticated_at, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:super_admins_tokens, [:super_admin_id])
    create unique_index(:super_admins_tokens, [:context, :token])
  end
end
