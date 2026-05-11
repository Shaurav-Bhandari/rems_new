# lib/bindu_backend/settings/restaurant_profile.ex
defmodule BinduBackend.Settings.RestaurantProfile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "restaurant_profiles" do
    # financial
    field :currency_code, :string, default: "USD"
    field :tax_registration_number, :string
    field :service_charge_pct, :decimal, default: 0.0
    field :tax_inclusive_pricing, :boolean, default: false
    field :default_tax_rate, :decimal, default: 0.0
    field :alcohol_tax_rate, :decimal, default: 0.0
    # operational
    field :auto_kot_firing, :boolean, default: true
    field :table_expiration_minutes, :integer, default: 30
    field :stock_warning_threshold, :integer, default: 10
    field :enable_happy_hour, :boolean, default: false
    field :happy_hour_start, :utc_datetime
    field :happy_hour_end, :utc_datetime
    field :happy_hour_discount, :decimal, default: 0.0
    # display
    field :language_iso, :string, default: "en"
    field :brand_primary_color, :string, default: "#000000"
    field :brand_secondary_color, :string, default: "#FFFFFF"
    field :logo_url, :string
    field :receipt_header, :string
    field :receipt_footer, :string
    # security
    field :require_manager_pin_for_void, :boolean, default: true
    field :require_manager_pin_for_discount, :boolean, default: true
    field :max_discount_pct_staff, :decimal, default: 0.0
    field :max_discount_pct_manager, :decimal, default: 20.0
    field :offsite_login_allowed, :boolean, default: false
    field :allowed_ip_ranges, :map, default: %{}
    # compliance
    field :gdpr_enabled, :boolean, default: false
    field :data_retention_days, :integer, default: 2555
    field :require_age_verification, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :currency_code, :tax_registration_number, :service_charge_pct,
      :tax_inclusive_pricing, :default_tax_rate, :alcohol_tax_rate,
      :auto_kot_firing, :table_expiration_minutes, :stock_warning_threshold,
      :enable_happy_hour, :happy_hour_start, :happy_hour_end, :happy_hour_discount,
      :language_iso, :brand_primary_color, :brand_secondary_color,
      :logo_url, :receipt_header, :receipt_footer,
      :require_manager_pin_for_void, :require_manager_pin_for_discount,
      :max_discount_pct_staff, :max_discount_pct_manager,
      :offsite_login_allowed, :allowed_ip_ranges,
      :gdpr_enabled, :data_retention_days, :require_age_verification
    ])
    |> validate_required([:currency_code])
    |> validate_format(:brand_primary_color, ~r/^#[0-9A-Fa-f]{6}$/, message: "must be valid hex color")
    |> validate_format(:brand_secondary_color, ~r/^#[0-9A-Fa-f]{6}$/, message: "must be valid hex color")
    |> validate_number(:service_charge_pct, greater_than_or_equal_to: 0)
    |> validate_number(:default_tax_rate, greater_than_or_equal_to: 0)
    |> validate_number(:happy_hour_discount, greater_than_or_equal_to: 0)
    |> validate_number(:data_retention_days, greater_than: 0)
  end
end
