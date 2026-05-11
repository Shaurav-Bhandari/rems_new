defmodule BinduBackend.Repo.Migrations.CreateSettingOverrides do
  use Ecto.Migration

  def change do
    create table(:setting_overrides) do
      add :key, :string
      add :value, :text
      add :min_role_level, :integer
      add :required_permission, :string
      add :priority, :integer
      add :inherit_from_parent, :boolean, default: false, null: false
      add :active_from, :utc_datetime
      add :active_until, :utc_datetime
      add :days_of_week, :map
      add :reason, :text
      add :created_by_id, references(:users, on_delete: :nothing)
      add :modified_by_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:setting_overrides, [:created_by_id])
    create index(:setting_overrides, [:modified_by_id])
  end
end
