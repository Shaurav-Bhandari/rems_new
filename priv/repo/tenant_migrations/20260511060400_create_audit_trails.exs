defmodule BinduBackend.Repo.TenantMigrations.CreateAuditTrails do
  use Ecto.Migration

  def change do
    create table(:audit_trails, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :event_type, :string
      add :event_category, :string
      add :event_description, :text
      add :severity, :string, null: false, default: "info"
      add :entity_type, :string
      add :entity_id, :string
      add :old_values, :map, default: "{}"
      add :new_values, :map, default: "{}"
      add :request_url, :text
      add :http_method, :string
      add :ip_address, :string
      add :user_agent, :text
      add :session_id, :string
      add :geolocation, :map, default: "{}"
      add :risk_level, :string, null: false, default: "low"
      add :requires_review, :boolean, default: false
      add :is_anomalous, :boolean, default: false
      add :anomaly_reason, :text
      add :compliance_flags, :map, default: "[]"
      add :is_pci_relevant, :boolean, default: false
      add :is_gdpr_relevant, :boolean, default: false
      add :timestamp, :utc_datetime, null: false
      add :reviewed_at, :utc_datetime
      add :user_id, references(:users, type: :uuid, on_delete: :nilify_all)
      add :reviewed_by_id, references(:users, type: :uuid, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create index(:audit_trails, [:user_id])
    create index(:audit_trails, [:reviewed_by_id])
    create index(:audit_trails, [:event_type])
    create index(:audit_trails, [:severity])
    create index(:audit_trails, [:risk_level])
    create index(:audit_trails, [:timestamp])
    create index(:audit_trails, [:requires_review])
    create index(:audit_trails, [:is_pci_relevant])
    create index(:audit_trails, [:is_gdpr_relevant])
    create index(:audit_trails, [:is_anomalous])
  end
end

