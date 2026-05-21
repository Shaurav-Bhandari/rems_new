defmodule BinduBackend.Repo.Migrations.CreatePlanFeatures do
  use Ecto.Migration

  def change do
    create table(:features, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      # "inventory", "analytics", "multi_branch"
      add :name, :string, null: false
      # "Inventory Management"
      add :display_name, :string, null: false
      add :description, :text
      # "operations", "reporting", "management"
      add :category, :string
      add :is_active, :boolean, default: true
      timestamps(type: :utc_datetime)
    end

    create unique_index(:features, [:name])
    create index(:features, [:category])

    # drop old plan_features and recreate as proper join table

    create table(:plan_features, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :plan_id, references(:plans, type: :uuid, on_delete: :delete_all), null: false
      add :feature_id, references(:features, type: :uuid, on_delete: :delete_all), null: false
      add :is_enabled, :boolean, default: true
      # nil = unlimited, 5 = max 5 restaurants etc
      add :limit_value, :integer
      timestamps(type: :utc_datetime)
    end

    create unique_index(:plan_features, [:plan_id, :feature_id])
    create index(:plan_features, [:plan_id])
    create index(:plan_features, [:feature_id])
  end
end
