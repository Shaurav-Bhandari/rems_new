defmodule BinduBackend.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Settings` context.
  """

  @doc """
  Generate a tenant_setting.
  """
  def tenant_setting_fixture(attrs \\ %{}) do
    {:ok, tenant_setting} =
      attrs
      |> Enum.into(%{
        data_type: "some data_type",
        default_value: "some default_value",
        description: "some description",
        domain: "some domain",
        is_system_locked: true,
        key: "some key",
        min_role_level: 42,
        modified_at: ~U[2026-05-10 06:24:00Z],
        previous_value: "some previous_value",
        required_permission: "some required_permission",
        validation_rule: "some validation_rule",
        value: "some value"
      })
      |> BinduBackend.Settings.create_tenant_setting()

    tenant_setting
  end

  @doc """
  Generate a restaurant_profile.
  """
  def restaurant_profile_fixture(attrs \\ %{}) do
    {:ok, restaurant_profile} =
      attrs
      |> Enum.into(%{
        alcohol_tax_rate: "120.5",
        allowed_ip_ranges: %{},
        auto_kot_firing: true,
        brand_primary_color: "some brand_primary_color",
        brand_secondary_color: "some brand_secondary_color",
        currency_code: "some currency_code",
        data_retention_days: 42,
        default_tax_rate: "120.5",
        enable_happy_hour: true,
        gdpr_enabled: true,
        happy_hour_discount: "120.5",
        happy_hour_end: ~U[2026-05-10 06:24:00Z],
        happy_hour_start: ~U[2026-05-10 06:24:00Z],
        language_iso: "some language_iso",
        logo_url: "some logo_url",
        max_discount_pct_manager: "120.5",
        max_discount_pct_staff: "120.5",
        offsite_login_allowed: true,
        receipt_footer: "some receipt_footer",
        receipt_header: "some receipt_header",
        require_age_verification: true,
        require_manager_pin_for_discount: true,
        require_manager_pin_for_void: true,
        service_charge_pct: "120.5",
        stock_warning_threshold: 42,
        table_expiration_minutes: 42,
        tax_inclusive_pricing: true,
        tax_registration_number: "some tax_registration_number"
      })
      |> BinduBackend.Settings.create_restaurant_profile()

    restaurant_profile
  end

  @doc """
  Generate a user_profile.
  """
  def user_profile_fixture(attrs \\ %{}) do
    {:ok, user_profile} =
      attrs
      |> Enum.into(%{
        average_order_value: "120.5",
        can_login_offsite: true,
        commission_rate: "120.5",
        default_shift: "some default_shift",
        department: "some department",
        elevation_expires_at: ~U[2026-05-10 06:24:00Z],
        elevation_reason: "some elevation_reason",
        employee_number: "some employee_number",
        employment_status: "some employment_status",
        hire_date: ~D[2026-05-10],
        hourly_rate: "120.5",
        job_title: "some job_title",
        last_performance_review: ~U[2026-05-10 06:24:00Z],
        manager_pin: "some manager_pin",
        monthly_salary: "120.5",
        notes: "some notes",
        notification_preferences: %{},
        performance_rating: "120.5",
        preferred_language: "some preferred_language",
        profile_type: "some profile_type",
        requires_pin_for_actions: true,
        role_level: 42,
        shift_pattern: "some shift_pattern",
        temporary_elevation: true,
        termination_date: ~D[2026-05-10],
        total_orders_processed: 42,
        weekly_hours: 42
      })
      |> BinduBackend.Settings.create_user_profile()

    user_profile
  end

  @doc """
  Generate a setting_override.
  """
  def setting_override_fixture(attrs \\ %{}) do
    {:ok, setting_override} =
      attrs
      |> Enum.into(%{
        active_from: ~U[2026-05-10 06:24:00Z],
        active_until: ~U[2026-05-10 06:24:00Z],
        days_of_week: %{},
        inherit_from_parent: true,
        key: "some key",
        min_role_level: 42,
        priority: 42,
        reason: "some reason",
        required_permission: "some required_permission",
        value: "some value"
      })
      |> BinduBackend.Settings.create_setting_override()

    setting_override
  end

  @doc """
  Generate a elevation_token.
  """
  def elevation_token_fixture(attrs \\ %{}) do
    {:ok, elevation_token} =
      attrs
      |> Enum.into(%{
        device_id: "some device_id",
        discount_amount: "120.5",
        expires_at: ~U[2026-05-10 06:24:00Z],
        ip_address: "some ip_address",
        is_used: true,
        permission: "some permission",
        request_reason: "some request_reason",
        token_hash: "some token_hash",
        used_at: ~U[2026-05-10 06:24:00Z]
      })
      |> BinduBackend.Settings.create_elevation_token()

    elevation_token
  end

  @doc """
  Generate a setting_audit_log.
  """
  def setting_audit_log_fixture(attrs \\ %{}) do
    {:ok, setting_audit_log} =
      attrs
      |> Enum.into(%{
        approved_at: ~U[2026-05-10 06:24:00Z],
        changed_at: ~U[2026-05-10 06:24:00Z],
        domain: "some domain",
        ip_address: "some ip_address",
        new_value: "some new_value",
        old_value: "some old_value",
        reason: "some reason",
        required_approval: true,
        role_level: 42,
        setting_key: "some setting_key",
        user_agent: "some user_agent",
        was_elevated: true
      })
      |> BinduBackend.Settings.create_setting_audit_log()

    setting_audit_log
  end
end
