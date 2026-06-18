defmodule BinduBackend.Repo.TenantMigrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :profile_type, :string
      add :role_level, :integer
      add :employee_number, :string
      add :department, :string
      add :job_title, :string
      add :hire_date, :date
      add :termination_date, :date
      add :employment_status, :string
      add :hourly_rate, :decimal
      add :monthly_salary, :decimal
      add :commission_rate, :decimal
      add :shift_pattern, :string
      add :default_shift, :string
      add :weekly_hours, :integer
      add :can_login_offsite, :boolean, default: false, null: false
      add :requires_pin_for_actions, :boolean, default: false, null: false
      add :manager_pin, :string
      add :temporary_elevation, :boolean, default: false, null: false
      add :elevation_expires_at, :utc_datetime
      add :elevation_reason, :string
      add :total_orders_processed, :integer
      add :average_order_value, :decimal
      add :last_performance_review, :utc_datetime
      add :performance_rating, :decimal
      add :preferred_language, :string
      add :notification_preferences, :map
      add :notes, :text
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_profiles, [:user_id])
  end
end

