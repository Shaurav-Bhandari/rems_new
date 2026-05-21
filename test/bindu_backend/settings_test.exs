defmodule BinduBackend.SettingsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Settings

  describe "tenant_settings" do
    alias BinduBackend.Settings.TenantSetting

    import BinduBackend.SettingsFixtures

    @invalid_attrs %{
      value: nil,
      domain: nil,
      description: nil,
      key: nil,
      data_type: nil,
      min_role_level: nil,
      required_permission: nil,
      is_system_locked: nil,
      previous_value: nil,
      validation_rule: nil,
      default_value: nil,
      modified_at: nil
    }

    test "list_tenant_settings/0 returns all tenant_settings" do
      tenant_setting = tenant_setting_fixture()
      assert Settings.list_tenant_settings() == [tenant_setting]
    end

    test "get_tenant_setting!/1 returns the tenant_setting with given id" do
      tenant_setting = tenant_setting_fixture()
      assert Settings.get_tenant_setting!(tenant_setting.id) == tenant_setting
    end

    test "create_tenant_setting/1 with valid data creates a tenant_setting" do
      valid_attrs = %{
        value: "some value",
        domain: "some domain",
        description: "some description",
        key: "some key",
        data_type: "some data_type",
        min_role_level: 42,
        required_permission: "some required_permission",
        is_system_locked: true,
        previous_value: "some previous_value",
        validation_rule: "some validation_rule",
        default_value: "some default_value",
        modified_at: ~U[2026-05-10 06:24:00Z]
      }

      assert {:ok, %TenantSetting{} = tenant_setting} =
               Settings.create_tenant_setting(valid_attrs)

      assert tenant_setting.value == "some value"
      assert tenant_setting.domain == "some domain"
      assert tenant_setting.description == "some description"
      assert tenant_setting.key == "some key"
      assert tenant_setting.data_type == "some data_type"
      assert tenant_setting.min_role_level == 42
      assert tenant_setting.required_permission == "some required_permission"
      assert tenant_setting.is_system_locked == true
      assert tenant_setting.previous_value == "some previous_value"
      assert tenant_setting.validation_rule == "some validation_rule"
      assert tenant_setting.default_value == "some default_value"
      assert tenant_setting.modified_at == ~U[2026-05-10 06:24:00Z]
    end

    test "create_tenant_setting/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_tenant_setting(@invalid_attrs)
    end

    test "update_tenant_setting/2 with valid data updates the tenant_setting" do
      tenant_setting = tenant_setting_fixture()

      update_attrs = %{
        value: "some updated value",
        domain: "some updated domain",
        description: "some updated description",
        key: "some updated key",
        data_type: "some updated data_type",
        min_role_level: 43,
        required_permission: "some updated required_permission",
        is_system_locked: false,
        previous_value: "some updated previous_value",
        validation_rule: "some updated validation_rule",
        default_value: "some updated default_value",
        modified_at: ~U[2026-05-11 06:24:00Z]
      }

      assert {:ok, %TenantSetting{} = tenant_setting} =
               Settings.update_tenant_setting(tenant_setting, update_attrs)

      assert tenant_setting.value == "some updated value"
      assert tenant_setting.domain == "some updated domain"
      assert tenant_setting.description == "some updated description"
      assert tenant_setting.key == "some updated key"
      assert tenant_setting.data_type == "some updated data_type"
      assert tenant_setting.min_role_level == 43
      assert tenant_setting.required_permission == "some updated required_permission"
      assert tenant_setting.is_system_locked == false
      assert tenant_setting.previous_value == "some updated previous_value"
      assert tenant_setting.validation_rule == "some updated validation_rule"
      assert tenant_setting.default_value == "some updated default_value"
      assert tenant_setting.modified_at == ~U[2026-05-11 06:24:00Z]
    end

    test "update_tenant_setting/2 with invalid data returns error changeset" do
      tenant_setting = tenant_setting_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Settings.update_tenant_setting(tenant_setting, @invalid_attrs)

      assert tenant_setting == Settings.get_tenant_setting!(tenant_setting.id)
    end

    test "delete_tenant_setting/1 deletes the tenant_setting" do
      tenant_setting = tenant_setting_fixture()
      assert {:ok, %TenantSetting{}} = Settings.delete_tenant_setting(tenant_setting)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_tenant_setting!(tenant_setting.id) end
    end

    test "change_tenant_setting/1 returns a tenant_setting changeset" do
      tenant_setting = tenant_setting_fixture()
      assert %Ecto.Changeset{} = Settings.change_tenant_setting(tenant_setting)
    end
  end

  describe "restaurant_profiles" do
    alias BinduBackend.Settings.RestaurantProfile

    import BinduBackend.SettingsFixtures

    @invalid_attrs %{
      currency_code: nil,
      tax_registration_number: nil,
      service_charge_pct: nil,
      tax_inclusive_pricing: nil,
      default_tax_rate: nil,
      alcohol_tax_rate: nil,
      auto_kot_firing: nil,
      table_expiration_minutes: nil,
      stock_warning_threshold: nil,
      enable_happy_hour: nil,
      happy_hour_start: nil,
      happy_hour_end: nil,
      happy_hour_discount: nil,
      language_iso: nil,
      brand_primary_color: nil,
      brand_secondary_color: nil,
      logo_url: nil,
      receipt_header: nil,
      receipt_footer: nil,
      require_manager_pin_for_void: nil,
      require_manager_pin_for_discount: nil,
      max_discount_pct_staff: nil,
      max_discount_pct_manager: nil,
      offsite_login_allowed: nil,
      allowed_ip_ranges: nil,
      gdpr_enabled: nil,
      data_retention_days: nil,
      require_age_verification: nil
    }

    test "list_restaurant_profiles/0 returns all restaurant_profiles" do
      restaurant_profile = restaurant_profile_fixture()
      assert Settings.list_restaurant_profiles() == [restaurant_profile]
    end

    test "get_restaurant_profile!/1 returns the restaurant_profile with given id" do
      restaurant_profile = restaurant_profile_fixture()
      assert Settings.get_restaurant_profile!(restaurant_profile.id) == restaurant_profile
    end

    test "create_restaurant_profile/1 with valid data creates a restaurant_profile" do
      valid_attrs = %{
        currency_code: "some currency_code",
        tax_registration_number: "some tax_registration_number",
        service_charge_pct: "120.5",
        tax_inclusive_pricing: true,
        default_tax_rate: "120.5",
        alcohol_tax_rate: "120.5",
        auto_kot_firing: true,
        table_expiration_minutes: 42,
        stock_warning_threshold: 42,
        enable_happy_hour: true,
        happy_hour_start: ~U[2026-05-10 06:24:00Z],
        happy_hour_end: ~U[2026-05-10 06:24:00Z],
        happy_hour_discount: "120.5",
        language_iso: "some language_iso",
        brand_primary_color: "some brand_primary_color",
        brand_secondary_color: "some brand_secondary_color",
        logo_url: "some logo_url",
        receipt_header: "some receipt_header",
        receipt_footer: "some receipt_footer",
        require_manager_pin_for_void: true,
        require_manager_pin_for_discount: true,
        max_discount_pct_staff: "120.5",
        max_discount_pct_manager: "120.5",
        offsite_login_allowed: true,
        allowed_ip_ranges: %{},
        gdpr_enabled: true,
        data_retention_days: 42,
        require_age_verification: true
      }

      assert {:ok, %RestaurantProfile{} = restaurant_profile} =
               Settings.create_restaurant_profile(valid_attrs)

      assert restaurant_profile.currency_code == "some currency_code"
      assert restaurant_profile.tax_registration_number == "some tax_registration_number"
      assert restaurant_profile.service_charge_pct == Decimal.new("120.5")
      assert restaurant_profile.tax_inclusive_pricing == true
      assert restaurant_profile.default_tax_rate == Decimal.new("120.5")
      assert restaurant_profile.alcohol_tax_rate == Decimal.new("120.5")
      assert restaurant_profile.auto_kot_firing == true
      assert restaurant_profile.table_expiration_minutes == 42
      assert restaurant_profile.stock_warning_threshold == 42
      assert restaurant_profile.enable_happy_hour == true
      assert restaurant_profile.happy_hour_start == ~U[2026-05-10 06:24:00Z]
      assert restaurant_profile.happy_hour_end == ~U[2026-05-10 06:24:00Z]
      assert restaurant_profile.happy_hour_discount == Decimal.new("120.5")
      assert restaurant_profile.language_iso == "some language_iso"
      assert restaurant_profile.brand_primary_color == "some brand_primary_color"
      assert restaurant_profile.brand_secondary_color == "some brand_secondary_color"
      assert restaurant_profile.logo_url == "some logo_url"
      assert restaurant_profile.receipt_header == "some receipt_header"
      assert restaurant_profile.receipt_footer == "some receipt_footer"
      assert restaurant_profile.require_manager_pin_for_void == true
      assert restaurant_profile.require_manager_pin_for_discount == true
      assert restaurant_profile.max_discount_pct_staff == Decimal.new("120.5")
      assert restaurant_profile.max_discount_pct_manager == Decimal.new("120.5")
      assert restaurant_profile.offsite_login_allowed == true
      assert restaurant_profile.allowed_ip_ranges == %{}
      assert restaurant_profile.gdpr_enabled == true
      assert restaurant_profile.data_retention_days == 42
      assert restaurant_profile.require_age_verification == true
    end

    test "create_restaurant_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_restaurant_profile(@invalid_attrs)
    end

    test "update_restaurant_profile/2 with valid data updates the restaurant_profile" do
      restaurant_profile = restaurant_profile_fixture()

      update_attrs = %{
        currency_code: "some updated currency_code",
        tax_registration_number: "some updated tax_registration_number",
        service_charge_pct: "456.7",
        tax_inclusive_pricing: false,
        default_tax_rate: "456.7",
        alcohol_tax_rate: "456.7",
        auto_kot_firing: false,
        table_expiration_minutes: 43,
        stock_warning_threshold: 43,
        enable_happy_hour: false,
        happy_hour_start: ~U[2026-05-11 06:24:00Z],
        happy_hour_end: ~U[2026-05-11 06:24:00Z],
        happy_hour_discount: "456.7",
        language_iso: "some updated language_iso",
        brand_primary_color: "some updated brand_primary_color",
        brand_secondary_color: "some updated brand_secondary_color",
        logo_url: "some updated logo_url",
        receipt_header: "some updated receipt_header",
        receipt_footer: "some updated receipt_footer",
        require_manager_pin_for_void: false,
        require_manager_pin_for_discount: false,
        max_discount_pct_staff: "456.7",
        max_discount_pct_manager: "456.7",
        offsite_login_allowed: false,
        allowed_ip_ranges: %{},
        gdpr_enabled: false,
        data_retention_days: 43,
        require_age_verification: false
      }

      assert {:ok, %RestaurantProfile{} = restaurant_profile} =
               Settings.update_restaurant_profile(restaurant_profile, update_attrs)

      assert restaurant_profile.currency_code == "some updated currency_code"
      assert restaurant_profile.tax_registration_number == "some updated tax_registration_number"
      assert restaurant_profile.service_charge_pct == Decimal.new("456.7")
      assert restaurant_profile.tax_inclusive_pricing == false
      assert restaurant_profile.default_tax_rate == Decimal.new("456.7")
      assert restaurant_profile.alcohol_tax_rate == Decimal.new("456.7")
      assert restaurant_profile.auto_kot_firing == false
      assert restaurant_profile.table_expiration_minutes == 43
      assert restaurant_profile.stock_warning_threshold == 43
      assert restaurant_profile.enable_happy_hour == false
      assert restaurant_profile.happy_hour_start == ~U[2026-05-11 06:24:00Z]
      assert restaurant_profile.happy_hour_end == ~U[2026-05-11 06:24:00Z]
      assert restaurant_profile.happy_hour_discount == Decimal.new("456.7")
      assert restaurant_profile.language_iso == "some updated language_iso"
      assert restaurant_profile.brand_primary_color == "some updated brand_primary_color"
      assert restaurant_profile.brand_secondary_color == "some updated brand_secondary_color"
      assert restaurant_profile.logo_url == "some updated logo_url"
      assert restaurant_profile.receipt_header == "some updated receipt_header"
      assert restaurant_profile.receipt_footer == "some updated receipt_footer"
      assert restaurant_profile.require_manager_pin_for_void == false
      assert restaurant_profile.require_manager_pin_for_discount == false
      assert restaurant_profile.max_discount_pct_staff == Decimal.new("456.7")
      assert restaurant_profile.max_discount_pct_manager == Decimal.new("456.7")
      assert restaurant_profile.offsite_login_allowed == false
      assert restaurant_profile.allowed_ip_ranges == %{}
      assert restaurant_profile.gdpr_enabled == false
      assert restaurant_profile.data_retention_days == 43
      assert restaurant_profile.require_age_verification == false
    end

    test "update_restaurant_profile/2 with invalid data returns error changeset" do
      restaurant_profile = restaurant_profile_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Settings.update_restaurant_profile(restaurant_profile, @invalid_attrs)

      assert restaurant_profile == Settings.get_restaurant_profile!(restaurant_profile.id)
    end

    test "delete_restaurant_profile/1 deletes the restaurant_profile" do
      restaurant_profile = restaurant_profile_fixture()
      assert {:ok, %RestaurantProfile{}} = Settings.delete_restaurant_profile(restaurant_profile)

      assert_raise Ecto.NoResultsError, fn ->
        Settings.get_restaurant_profile!(restaurant_profile.id)
      end
    end

    test "change_restaurant_profile/1 returns a restaurant_profile changeset" do
      restaurant_profile = restaurant_profile_fixture()
      assert %Ecto.Changeset{} = Settings.change_restaurant_profile(restaurant_profile)
    end
  end

  describe "user_profiles" do
    alias BinduBackend.Settings.UserProfile

    import BinduBackend.SettingsFixtures

    @invalid_attrs %{
      profile_type: nil,
      role_level: nil,
      employee_number: nil,
      department: nil,
      job_title: nil,
      hire_date: nil,
      termination_date: nil,
      employment_status: nil,
      hourly_rate: nil,
      monthly_salary: nil,
      commission_rate: nil,
      shift_pattern: nil,
      default_shift: nil,
      weekly_hours: nil,
      can_login_offsite: nil,
      requires_pin_for_actions: nil,
      manager_pin: nil,
      temporary_elevation: nil,
      elevation_expires_at: nil,
      elevation_reason: nil,
      total_orders_processed: nil,
      average_order_value: nil,
      last_performance_review: nil,
      performance_rating: nil,
      preferred_language: nil,
      notification_preferences: nil,
      notes: nil
    }

    test "list_user_profiles/0 returns all user_profiles" do
      user_profile = user_profile_fixture()
      assert Settings.list_user_profiles() == [user_profile]
    end

    test "get_user_profile!/1 returns the user_profile with given id" do
      user_profile = user_profile_fixture()
      assert Settings.get_user_profile!(user_profile.id) == user_profile
    end

    test "create_user_profile/1 with valid data creates a user_profile" do
      valid_attrs = %{
        profile_type: "some profile_type",
        role_level: 42,
        employee_number: "some employee_number",
        department: "some department",
        job_title: "some job_title",
        hire_date: ~D[2026-05-10],
        termination_date: ~D[2026-05-10],
        employment_status: "some employment_status",
        hourly_rate: "120.5",
        monthly_salary: "120.5",
        commission_rate: "120.5",
        shift_pattern: "some shift_pattern",
        default_shift: "some default_shift",
        weekly_hours: 42,
        can_login_offsite: true,
        requires_pin_for_actions: true,
        manager_pin: "some manager_pin",
        temporary_elevation: true,
        elevation_expires_at: ~U[2026-05-10 06:24:00Z],
        elevation_reason: "some elevation_reason",
        total_orders_processed: 42,
        average_order_value: "120.5",
        last_performance_review: ~U[2026-05-10 06:24:00Z],
        performance_rating: "120.5",
        preferred_language: "some preferred_language",
        notification_preferences: %{},
        notes: "some notes"
      }

      assert {:ok, %UserProfile{} = user_profile} = Settings.create_user_profile(valid_attrs)
      assert user_profile.profile_type == "some profile_type"
      assert user_profile.role_level == 42
      assert user_profile.employee_number == "some employee_number"
      assert user_profile.department == "some department"
      assert user_profile.job_title == "some job_title"
      assert user_profile.hire_date == ~D[2026-05-10]
      assert user_profile.termination_date == ~D[2026-05-10]
      assert user_profile.employment_status == "some employment_status"
      assert user_profile.hourly_rate == Decimal.new("120.5")
      assert user_profile.monthly_salary == Decimal.new("120.5")
      assert user_profile.commission_rate == Decimal.new("120.5")
      assert user_profile.shift_pattern == "some shift_pattern"
      assert user_profile.default_shift == "some default_shift"
      assert user_profile.weekly_hours == 42
      assert user_profile.can_login_offsite == true
      assert user_profile.requires_pin_for_actions == true
      assert user_profile.manager_pin == "some manager_pin"
      assert user_profile.temporary_elevation == true
      assert user_profile.elevation_expires_at == ~U[2026-05-10 06:24:00Z]
      assert user_profile.elevation_reason == "some elevation_reason"
      assert user_profile.total_orders_processed == 42
      assert user_profile.average_order_value == Decimal.new("120.5")
      assert user_profile.last_performance_review == ~U[2026-05-10 06:24:00Z]
      assert user_profile.performance_rating == Decimal.new("120.5")
      assert user_profile.preferred_language == "some preferred_language"
      assert user_profile.notification_preferences == %{}
      assert user_profile.notes == "some notes"
    end

    test "create_user_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_user_profile(@invalid_attrs)
    end

    test "update_user_profile/2 with valid data updates the user_profile" do
      user_profile = user_profile_fixture()

      update_attrs = %{
        profile_type: "some updated profile_type",
        role_level: 43,
        employee_number: "some updated employee_number",
        department: "some updated department",
        job_title: "some updated job_title",
        hire_date: ~D[2026-05-11],
        termination_date: ~D[2026-05-11],
        employment_status: "some updated employment_status",
        hourly_rate: "456.7",
        monthly_salary: "456.7",
        commission_rate: "456.7",
        shift_pattern: "some updated shift_pattern",
        default_shift: "some updated default_shift",
        weekly_hours: 43,
        can_login_offsite: false,
        requires_pin_for_actions: false,
        manager_pin: "some updated manager_pin",
        temporary_elevation: false,
        elevation_expires_at: ~U[2026-05-11 06:24:00Z],
        elevation_reason: "some updated elevation_reason",
        total_orders_processed: 43,
        average_order_value: "456.7",
        last_performance_review: ~U[2026-05-11 06:24:00Z],
        performance_rating: "456.7",
        preferred_language: "some updated preferred_language",
        notification_preferences: %{},
        notes: "some updated notes"
      }

      assert {:ok, %UserProfile{} = user_profile} =
               Settings.update_user_profile(user_profile, update_attrs)

      assert user_profile.profile_type == "some updated profile_type"
      assert user_profile.role_level == 43
      assert user_profile.employee_number == "some updated employee_number"
      assert user_profile.department == "some updated department"
      assert user_profile.job_title == "some updated job_title"
      assert user_profile.hire_date == ~D[2026-05-11]
      assert user_profile.termination_date == ~D[2026-05-11]
      assert user_profile.employment_status == "some updated employment_status"
      assert user_profile.hourly_rate == Decimal.new("456.7")
      assert user_profile.monthly_salary == Decimal.new("456.7")
      assert user_profile.commission_rate == Decimal.new("456.7")
      assert user_profile.shift_pattern == "some updated shift_pattern"
      assert user_profile.default_shift == "some updated default_shift"
      assert user_profile.weekly_hours == 43
      assert user_profile.can_login_offsite == false
      assert user_profile.requires_pin_for_actions == false
      assert user_profile.manager_pin == "some updated manager_pin"
      assert user_profile.temporary_elevation == false
      assert user_profile.elevation_expires_at == ~U[2026-05-11 06:24:00Z]
      assert user_profile.elevation_reason == "some updated elevation_reason"
      assert user_profile.total_orders_processed == 43
      assert user_profile.average_order_value == Decimal.new("456.7")
      assert user_profile.last_performance_review == ~U[2026-05-11 06:24:00Z]
      assert user_profile.performance_rating == Decimal.new("456.7")
      assert user_profile.preferred_language == "some updated preferred_language"
      assert user_profile.notification_preferences == %{}
      assert user_profile.notes == "some updated notes"
    end

    test "update_user_profile/2 with invalid data returns error changeset" do
      user_profile = user_profile_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Settings.update_user_profile(user_profile, @invalid_attrs)

      assert user_profile == Settings.get_user_profile!(user_profile.id)
    end

    test "delete_user_profile/1 deletes the user_profile" do
      user_profile = user_profile_fixture()
      assert {:ok, %UserProfile{}} = Settings.delete_user_profile(user_profile)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_user_profile!(user_profile.id) end
    end

    test "change_user_profile/1 returns a user_profile changeset" do
      user_profile = user_profile_fixture()
      assert %Ecto.Changeset{} = Settings.change_user_profile(user_profile)
    end
  end

  describe "setting_overrides" do
    alias BinduBackend.Settings.SettingOverride

    import BinduBackend.SettingsFixtures

    @invalid_attrs %{
      priority: nil,
      reason: nil,
      value: nil,
      key: nil,
      min_role_level: nil,
      required_permission: nil,
      inherit_from_parent: nil,
      active_from: nil,
      active_until: nil,
      days_of_week: nil
    }

    test "list_setting_overrides/0 returns all setting_overrides" do
      setting_override = setting_override_fixture()
      assert Settings.list_setting_overrides() == [setting_override]
    end

    test "get_setting_override!/1 returns the setting_override with given id" do
      setting_override = setting_override_fixture()
      assert Settings.get_setting_override!(setting_override.id) == setting_override
    end

    test "create_setting_override/1 with valid data creates a setting_override" do
      valid_attrs = %{
        priority: 42,
        reason: "some reason",
        value: "some value",
        key: "some key",
        min_role_level: 42,
        required_permission: "some required_permission",
        inherit_from_parent: true,
        active_from: ~U[2026-05-10 06:24:00Z],
        active_until: ~U[2026-05-10 06:24:00Z],
        days_of_week: %{}
      }

      assert {:ok, %SettingOverride{} = setting_override} =
               Settings.create_setting_override(valid_attrs)

      assert setting_override.priority == 42
      assert setting_override.reason == "some reason"
      assert setting_override.value == "some value"
      assert setting_override.key == "some key"
      assert setting_override.min_role_level == 42
      assert setting_override.required_permission == "some required_permission"
      assert setting_override.inherit_from_parent == true
      assert setting_override.active_from == ~U[2026-05-10 06:24:00Z]
      assert setting_override.active_until == ~U[2026-05-10 06:24:00Z]
      assert setting_override.days_of_week == %{}
    end

    test "create_setting_override/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_setting_override(@invalid_attrs)
    end

    test "update_setting_override/2 with valid data updates the setting_override" do
      setting_override = setting_override_fixture()

      update_attrs = %{
        priority: 43,
        reason: "some updated reason",
        value: "some updated value",
        key: "some updated key",
        min_role_level: 43,
        required_permission: "some updated required_permission",
        inherit_from_parent: false,
        active_from: ~U[2026-05-11 06:24:00Z],
        active_until: ~U[2026-05-11 06:24:00Z],
        days_of_week: %{}
      }

      assert {:ok, %SettingOverride{} = setting_override} =
               Settings.update_setting_override(setting_override, update_attrs)

      assert setting_override.priority == 43
      assert setting_override.reason == "some updated reason"
      assert setting_override.value == "some updated value"
      assert setting_override.key == "some updated key"
      assert setting_override.min_role_level == 43
      assert setting_override.required_permission == "some updated required_permission"
      assert setting_override.inherit_from_parent == false
      assert setting_override.active_from == ~U[2026-05-11 06:24:00Z]
      assert setting_override.active_until == ~U[2026-05-11 06:24:00Z]
      assert setting_override.days_of_week == %{}
    end

    test "update_setting_override/2 with invalid data returns error changeset" do
      setting_override = setting_override_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Settings.update_setting_override(setting_override, @invalid_attrs)

      assert setting_override == Settings.get_setting_override!(setting_override.id)
    end

    test "delete_setting_override/1 deletes the setting_override" do
      setting_override = setting_override_fixture()
      assert {:ok, %SettingOverride{}} = Settings.delete_setting_override(setting_override)

      assert_raise Ecto.NoResultsError, fn ->
        Settings.get_setting_override!(setting_override.id)
      end
    end

    test "change_setting_override/1 returns a setting_override changeset" do
      setting_override = setting_override_fixture()
      assert %Ecto.Changeset{} = Settings.change_setting_override(setting_override)
    end
  end

  describe "elevation_tokens" do
    alias BinduBackend.Settings.ElevationToken

    import BinduBackend.SettingsFixtures

    @invalid_attrs %{
      is_used: nil,
      token_hash: nil,
      permission: nil,
      expires_at: nil,
      used_at: nil,
      request_reason: nil,
      discount_amount: nil,
      ip_address: nil,
      device_id: nil
    }

    test "list_elevation_tokens/0 returns all elevation_tokens" do
      elevation_token = elevation_token_fixture()
      assert Settings.list_elevation_tokens() == [elevation_token]
    end

    test "get_elevation_token!/1 returns the elevation_token with given id" do
      elevation_token = elevation_token_fixture()
      assert Settings.get_elevation_token!(elevation_token.id) == elevation_token
    end

    test "create_elevation_token/1 with valid data creates a elevation_token" do
      valid_attrs = %{
        is_used: true,
        token_hash: "some token_hash",
        permission: "some permission",
        expires_at: ~U[2026-05-10 06:24:00Z],
        used_at: ~U[2026-05-10 06:24:00Z],
        request_reason: "some request_reason",
        discount_amount: "120.5",
        ip_address: "some ip_address",
        device_id: "some device_id"
      }

      assert {:ok, %ElevationToken{} = elevation_token} =
               Settings.create_elevation_token(valid_attrs)

      assert elevation_token.is_used == true
      assert elevation_token.token_hash == "some token_hash"
      assert elevation_token.permission == "some permission"
      assert elevation_token.expires_at == ~U[2026-05-10 06:24:00Z]
      assert elevation_token.used_at == ~U[2026-05-10 06:24:00Z]
      assert elevation_token.request_reason == "some request_reason"
      assert elevation_token.discount_amount == Decimal.new("120.5")
      assert elevation_token.ip_address == "some ip_address"
      assert elevation_token.device_id == "some device_id"
    end

    test "create_elevation_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_elevation_token(@invalid_attrs)
    end

    test "update_elevation_token/2 with valid data updates the elevation_token" do
      elevation_token = elevation_token_fixture()

      update_attrs = %{
        is_used: false,
        token_hash: "some updated token_hash",
        permission: "some updated permission",
        expires_at: ~U[2026-05-11 06:24:00Z],
        used_at: ~U[2026-05-11 06:24:00Z],
        request_reason: "some updated request_reason",
        discount_amount: "456.7",
        ip_address: "some updated ip_address",
        device_id: "some updated device_id"
      }

      assert {:ok, %ElevationToken{} = elevation_token} =
               Settings.update_elevation_token(elevation_token, update_attrs)

      assert elevation_token.is_used == false
      assert elevation_token.token_hash == "some updated token_hash"
      assert elevation_token.permission == "some updated permission"
      assert elevation_token.expires_at == ~U[2026-05-11 06:24:00Z]
      assert elevation_token.used_at == ~U[2026-05-11 06:24:00Z]
      assert elevation_token.request_reason == "some updated request_reason"
      assert elevation_token.discount_amount == Decimal.new("456.7")
      assert elevation_token.ip_address == "some updated ip_address"
      assert elevation_token.device_id == "some updated device_id"
    end

    test "update_elevation_token/2 with invalid data returns error changeset" do
      elevation_token = elevation_token_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Settings.update_elevation_token(elevation_token, @invalid_attrs)

      assert elevation_token == Settings.get_elevation_token!(elevation_token.id)
    end

    test "delete_elevation_token/1 deletes the elevation_token" do
      elevation_token = elevation_token_fixture()
      assert {:ok, %ElevationToken{}} = Settings.delete_elevation_token(elevation_token)

      assert_raise Ecto.NoResultsError, fn ->
        Settings.get_elevation_token!(elevation_token.id)
      end
    end

    test "change_elevation_token/1 returns a elevation_token changeset" do
      elevation_token = elevation_token_fixture()
      assert %Ecto.Changeset{} = Settings.change_elevation_token(elevation_token)
    end
  end

  describe "setting_audit_logs" do
    alias BinduBackend.Settings.SettingAuditLog

    import BinduBackend.SettingsFixtures

    @invalid_attrs %{
      reason: nil,
      domain: nil,
      new_value: nil,
      setting_key: nil,
      old_value: nil,
      changed_at: nil,
      ip_address: nil,
      user_agent: nil,
      role_level: nil,
      was_elevated: nil,
      required_approval: nil,
      approved_at: nil
    }

    test "list_setting_audit_logs/0 returns all setting_audit_logs" do
      setting_audit_log = setting_audit_log_fixture()
      assert Settings.list_setting_audit_logs() == [setting_audit_log]
    end

    test "get_setting_audit_log!/1 returns the setting_audit_log with given id" do
      setting_audit_log = setting_audit_log_fixture()
      assert Settings.get_setting_audit_log!(setting_audit_log.id) == setting_audit_log
    end

    test "create_setting_audit_log/1 with valid data creates a setting_audit_log" do
      valid_attrs = %{
        reason: "some reason",
        domain: "some domain",
        new_value: "some new_value",
        setting_key: "some setting_key",
        old_value: "some old_value",
        changed_at: ~U[2026-05-10 06:24:00Z],
        ip_address: "some ip_address",
        user_agent: "some user_agent",
        role_level: 42,
        was_elevated: true,
        required_approval: true,
        approved_at: ~U[2026-05-10 06:24:00Z]
      }

      assert {:ok, %SettingAuditLog{} = setting_audit_log} =
               Settings.create_setting_audit_log(valid_attrs)

      assert setting_audit_log.reason == "some reason"
      assert setting_audit_log.domain == "some domain"
      assert setting_audit_log.new_value == "some new_value"
      assert setting_audit_log.setting_key == "some setting_key"
      assert setting_audit_log.old_value == "some old_value"
      assert setting_audit_log.changed_at == ~U[2026-05-10 06:24:00Z]
      assert setting_audit_log.ip_address == "some ip_address"
      assert setting_audit_log.user_agent == "some user_agent"
      assert setting_audit_log.role_level == 42
      assert setting_audit_log.was_elevated == true
      assert setting_audit_log.required_approval == true
      assert setting_audit_log.approved_at == ~U[2026-05-10 06:24:00Z]
    end

    test "create_setting_audit_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_setting_audit_log(@invalid_attrs)
    end

    test "update_setting_audit_log/2 with valid data updates the setting_audit_log" do
      setting_audit_log = setting_audit_log_fixture()

      update_attrs = %{
        reason: "some updated reason",
        domain: "some updated domain",
        new_value: "some updated new_value",
        setting_key: "some updated setting_key",
        old_value: "some updated old_value",
        changed_at: ~U[2026-05-11 06:24:00Z],
        ip_address: "some updated ip_address",
        user_agent: "some updated user_agent",
        role_level: 43,
        was_elevated: false,
        required_approval: false,
        approved_at: ~U[2026-05-11 06:24:00Z]
      }

      assert {:ok, %SettingAuditLog{} = setting_audit_log} =
               Settings.update_setting_audit_log(setting_audit_log, update_attrs)

      assert setting_audit_log.reason == "some updated reason"
      assert setting_audit_log.domain == "some updated domain"
      assert setting_audit_log.new_value == "some updated new_value"
      assert setting_audit_log.setting_key == "some updated setting_key"
      assert setting_audit_log.old_value == "some updated old_value"
      assert setting_audit_log.changed_at == ~U[2026-05-11 06:24:00Z]
      assert setting_audit_log.ip_address == "some updated ip_address"
      assert setting_audit_log.user_agent == "some updated user_agent"
      assert setting_audit_log.role_level == 43
      assert setting_audit_log.was_elevated == false
      assert setting_audit_log.required_approval == false
      assert setting_audit_log.approved_at == ~U[2026-05-11 06:24:00Z]
    end

    test "update_setting_audit_log/2 with invalid data returns error changeset" do
      setting_audit_log = setting_audit_log_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Settings.update_setting_audit_log(setting_audit_log, @invalid_attrs)

      assert setting_audit_log == Settings.get_setting_audit_log!(setting_audit_log.id)
    end

    test "delete_setting_audit_log/1 deletes the setting_audit_log" do
      setting_audit_log = setting_audit_log_fixture()
      assert {:ok, %SettingAuditLog{}} = Settings.delete_setting_audit_log(setting_audit_log)

      assert_raise Ecto.NoResultsError, fn ->
        Settings.get_setting_audit_log!(setting_audit_log.id)
      end
    end

    test "change_setting_audit_log/1 returns a setting_audit_log changeset" do
      setting_audit_log = setting_audit_log_fixture()
      assert %Ecto.Changeset{} = Settings.change_setting_audit_log(setting_audit_log)
    end
  end
end
