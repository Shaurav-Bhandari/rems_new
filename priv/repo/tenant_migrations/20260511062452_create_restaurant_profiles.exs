defmodule BinduBackend.Repo.TenantMigrations.CreateRestaurantProfiles do
  use Ecto.Migration

  def change do
    create table(:restaurant_profiles, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :currency_code, :string
      add :tax_registration_number, :string
      add :service_charge_pct, :decimal
      add :tax_inclusive_pricing, :boolean, default: false, null: false
      add :default_tax_rate, :decimal
      add :alcohol_tax_rate, :decimal
      add :auto_kot_firing, :boolean, default: false, null: false
      add :table_expiration_minutes, :integer
      add :stock_warning_threshold, :integer
      add :enable_happy_hour, :boolean, default: false, null: false
      add :happy_hour_start, :utc_datetime
      add :happy_hour_end, :utc_datetime
      add :happy_hour_discount, :decimal
      add :language_iso, :string
      add :brand_primary_color, :string
      add :brand_secondary_color, :string
      add :logo_url, :text
      add :receipt_header, :text
      add :receipt_footer, :text
      add :require_manager_pin_for_void, :boolean, default: false, null: false
      add :require_manager_pin_for_discount, :boolean, default: false, null: false
      add :max_discount_pct_staff, :decimal
      add :max_discount_pct_manager, :decimal
      add :offsite_login_allowed, :boolean, default: false, null: false
      add :allowed_ip_ranges, :map
      add :gdpr_enabled, :boolean, default: false, null: false
      add :data_retention_days, :integer
      add :require_age_verification, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end

