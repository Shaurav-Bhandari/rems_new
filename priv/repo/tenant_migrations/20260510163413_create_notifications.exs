defmodule BinduBackend.Repo.TenantMigrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :user_id, references(:users, type: :uuid, on_delete: :restrict), null: false
      add :message, :text
      add :notification_type, :string
      add :is_read, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:notifications, [:user_id])

    create table(:webhook_integrations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :url, :string, null: false
      add :event_type, :string, null: false
      add :secret_token, :string
      add :is_active, :boolean, default: true

      timestamps(type: :utc_datetime)
    end

    create index(:webhook_integrations, [:event_type])
    create index(:webhook_integrations, [:is_active])
    create unique_index(:webhook_integrations, [:url, :event_type])
  end
end

