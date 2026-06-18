defmodule BinduBackend.Repo.TenantMigrations.CreateTenantSettings do
  use Ecto.Migration

  def change do
    create table(:tenant_settings, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :key, :string
      add :value, :text
      add :domain, :string
      add :data_type, :string
      add :min_role_level, :integer
      add :required_permission, :string
      add :is_system_locked, :boolean, default: false, null: false
      add :previous_value, :text
      add :description, :text
      add :validation_rule, :text
      add :default_value, :string
      add :modified_at, :utc_datetime
      add :modified_by_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tenant_settings, [:modified_by_id])
  end
end

