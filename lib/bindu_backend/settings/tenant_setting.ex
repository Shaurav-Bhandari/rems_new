# lib/bindu_backend/settings/tenant_setting.ex
defmodule BinduBackend.Settings.TenantSetting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @valid_domains ~w(financial operational display security compliance integration)
  @valid_data_types ~w(string integer float boolean json)

  schema "tenant_settings" do
    field :key, :string
    field :value, :string
    field :domain, :string
    field :data_type, :string
    field :min_role_level, :integer, default: 1
    field :required_permission, :string
    field :is_system_locked, :boolean, default: false
    field :previous_value, :string
    field :description, :string
    field :validation_rule, :string
    field :default_value, :string
    field :modified_at, :utc_datetime

    belongs_to :modified_by, BinduBackend.Accounts.User, foreign_key: :modified_by_id

    timestamps(type: :utc_datetime)
  end

  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [
      :key,
      :value,
      :domain,
      :data_type,
      :min_role_level,
      :required_permission,
      :is_system_locked,
      :previous_value,
      :description,
      :validation_rule,
      :default_value,
      :modified_at,
      :modified_by_id
    ])
    |> validate_required([:key, :value, :domain, :data_type, :modified_at, :modified_by_id])
    |> validate_inclusion(:domain, @valid_domains)
    |> validate_inclusion(:data_type, @valid_data_types)
    |> unique_constraint(:key)
    |> foreign_key_constraint(:modified_by_id)
  end
end
