defmodule BinduBackend.Repo.Migrations.CreateTenantOnboarding do
  use Ecto.Migration

  def change do
    create table(:tenant_onboarding, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :tenant_id, references(:tenants, type: :uuid, on_delete: :delete_all), null: false
      add :current_step, :string, null: false, default: "account_created"
      add :is_completed, :boolean, default: false, null: false
      add :account_created, :boolean, default: false, null: false
      add :plan_selected, :boolean, default: false, null: false
      add :restaurant_created, :boolean, default: false, null: false
      add :menu_configured, :boolean, default: false, null: false
      add :staff_invited, :boolean, default: false, null: false
      add :payment_configured, :boolean, default: false, null: false
      add :inventory_setup, :boolean, default: false, null: false
      add :completed_at, :time
      add :user_id, :uuid

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tenant_onboarding, [:tenant_id])
    create index(:tenant_onboarding, [:current_step])
    create index(:tenant_onboarding, [:is_completed])
  end
end
