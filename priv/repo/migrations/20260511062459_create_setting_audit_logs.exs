defmodule BinduBackend.Repo.Migrations.CreateSettingAuditLogs do
  use Ecto.Migration

  def change do
    create table(:setting_audit_logs) do
      add :setting_key, :string
      add :domain, :string
      add :old_value, :text
      add :new_value, :text
      add :changed_at, :utc_datetime
      add :reason, :text
      add :ip_address, :string
      add :user_agent, :text
      add :role_level, :integer
      add :was_elevated, :boolean, default: false, null: false
      add :required_approval, :boolean, default: false, null: false
      add :approved_at, :utc_datetime
      add :changed_by_id, references(:users, on_delete: :nothing)
      add :approved_by_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:setting_audit_logs, [:changed_by_id])
    create index(:setting_audit_logs, [:approved_by_id])
  end
end
