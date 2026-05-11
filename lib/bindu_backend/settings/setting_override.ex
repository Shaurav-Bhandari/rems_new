# lib/bindu_backend/settings/setting_override.ex
defmodule BinduBackend.Settings.SettingOverride do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "setting_overrides" do
    field :key, :string
    field :value, :string
    field :min_role_level, :integer, default: 1
    field :required_permission, :string
    field :priority, :integer, default: 0
    field :inherit_from_parent, :boolean, default: true
    field :active_from, :utc_datetime
    field :active_until, :utc_datetime
    field :days_of_week, :map, default: %{}
    field :reason, :string

    belongs_to :created_by, BinduBackend.Accounts.User, foreign_key: :created_by_id
    belongs_to :modified_by, BinduBackend.Accounts.User, foreign_key: :modified_by_id

    timestamps(type: :utc_datetime)
  end

  def changeset(override, attrs) do
    override
    |> cast(attrs, [:key, :value, :min_role_level, :required_permission,
        :priority, :inherit_from_parent, :active_from, :active_until,
        :days_of_week, :reason, :created_by_id, :modified_by_id])
    |> validate_required([:key, :value, :created_by_id, :modified_by_id])
    |> unique_constraint(:key)
    |> foreign_key_constraint(:created_by_id)
    |> foreign_key_constraint(:modified_by_id)
  end
end
