defmodule BinduBackend.Repo.TenantMigrations.CreateElevationTokens do
  use Ecto.Migration

  def change do
    create table(:elevation_tokens) do
      add :token_hash, :string
      add :permission, :string
      add :expires_at, :utc_datetime
      add :is_used, :boolean, default: false, null: false
      add :used_at, :utc_datetime
      add :request_reason, :text
      add :discount_amount, :decimal
      add :ip_address, :string
      add :device_id, :string
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)
      add :manager_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:elevation_tokens, [:user_id])
    create index(:elevation_tokens, [:manager_id])
  end
end

