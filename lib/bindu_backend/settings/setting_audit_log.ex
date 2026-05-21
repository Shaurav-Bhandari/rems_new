# lib/bindu_backend/settings/setting_audit_log.ex
defmodule BinduBackend.Settings.SettingAuditLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "setting_audit_logs" do
    field :setting_key, :string
    field :domain, :string
    field :old_value, :string
    field :new_value, :string
    field :changed_at, :utc_datetime
    field :reason, :string
    field :ip_address, :string
    field :user_agent, :string
    field :role_level, :integer
    field :was_elevated, :boolean, default: false
    field :required_approval, :boolean, default: false
    field :approved_at, :utc_datetime

    belongs_to :changed_by, BinduBackend.Accounts.User, foreign_key: :changed_by_id
    belongs_to :approved_by, BinduBackend.Accounts.User, foreign_key: :approved_by_id

    timestamps(type: :utc_datetime)
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [
      :setting_key,
      :domain,
      :old_value,
      :new_value,
      :changed_at,
      :reason,
      :ip_address,
      :user_agent,
      :role_level,
      :was_elevated,
      :required_approval,
      :approved_at,
      :changed_by_id,
      :approved_by_id
    ])
    |> validate_required([:setting_key, :domain, :changed_at, :role_level, :changed_by_id])
    |> foreign_key_constraint(:changed_by_id)
    |> foreign_key_constraint(:approved_by_id)
  end
end
