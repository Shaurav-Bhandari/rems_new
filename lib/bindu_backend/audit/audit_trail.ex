# lib/bindu_backend/audit/audit_trail.ex
defmodule BinduBackend.Audit.AuditTrail do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @valid_severities ~w(info warning error critical)
  @valid_risk_levels ~w(none low medium high critical)

  schema "audit_trails" do
    field :event_type, :string
    field :event_category, :string
    field :event_description, :string
    field :severity, :string, default: "info"
    field :entity_type, :string
    field :entity_id, :string
    field :old_values, :map, default: %{}
    field :new_values, :map, default: %{}
    field :request_url, :string
    field :http_method, :string
    field :ip_address, :string
    field :user_agent, :string
    field :session_id, :string
    field :geolocation, :map, default: %{}
    field :risk_level, :string, default: "low"
    field :requires_review, :boolean, default: false
    field :is_anomalous, :boolean, default: false
    field :anomaly_reason, :string
    field :compliance_flags, :map, default: %{}
    field :is_pci_relevant, :boolean, default: false
    field :is_gdpr_relevant, :boolean, default: false
    field :timestamp, :utc_datetime
    field :reviewed_at, :utc_datetime

    belongs_to :user, BinduBackend.Accounts.User
    belongs_to :reviewed_by, BinduBackend.Accounts.User, foreign_key: :reviewed_by_id

    timestamps(type: :utc_datetime)
  end

  def changeset(trail, attrs) do
    trail
    |> cast(attrs, [
      :event_type, :event_category, :event_description,
      :severity, :entity_type, :entity_id,
      :old_values, :new_values, :request_url,
      :http_method, :ip_address, :user_agent,
      :session_id, :geolocation, :risk_level,
      :requires_review, :is_anomalous, :anomaly_reason,
      :compliance_flags, :is_pci_relevant, :is_gdpr_relevant,
      :timestamp, :reviewed_at, :user_id, :reviewed_by_id
    ])
    |> validate_required([:severity, :risk_level, :timestamp])
    |> validate_inclusion(:severity, @valid_severities)
    |> validate_inclusion(:risk_level, @valid_risk_levels)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:reviewed_by_id)
  end
end
