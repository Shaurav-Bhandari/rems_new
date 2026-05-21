defmodule BinduBackend.TenantsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Tenants

  describe "tenants" do
    alias BinduBackend.Tenants.Tenant

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.TenantsFixtures

    @invalid_attrs %{
      name: nil,
      status: nil,
      domain: nil,
      slug: nil,
      schema_name: nil,
      is_active: nil
    }

    test "list_tenants/1 returns all scoped tenants" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tenant = tenant_fixture(scope)
      other_tenant = tenant_fixture(other_scope)
      assert Tenants.list_tenants(scope) == [tenant]
      assert Tenants.list_tenants(other_scope) == [other_tenant]
    end

    test "get_tenant!/2 returns the tenant with given id" do
      scope = user_scope_fixture()
      tenant = tenant_fixture(scope)
      other_scope = user_scope_fixture()
      assert Tenants.get_tenant!(scope, tenant.id) == tenant
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_tenant!(other_scope, tenant.id) end
    end

    test "create_tenant/2 with valid data creates a tenant" do
      valid_attrs = %{
        name: "some name",
        status: "some status",
        domain: "some domain",
        slug: "some slug",
        schema_name: "some schema_name",
        is_active: true
      }

      scope = user_scope_fixture()

      assert {:ok, %Tenant{} = tenant} = Tenants.create_tenant(scope, valid_attrs)
      assert tenant.name == "some name"
      assert tenant.status == "some status"
      assert tenant.domain == "some domain"
      assert tenant.slug == "some slug"
      assert tenant.schema_name == "some schema_name"
      assert tenant.is_active == true
      assert tenant.user_id == scope.user.id
    end

    test "create_tenant/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.create_tenant(scope, @invalid_attrs)
    end

    test "update_tenant/3 with valid data updates the tenant" do
      scope = user_scope_fixture()
      tenant = tenant_fixture(scope)

      update_attrs = %{
        name: "some updated name",
        status: "some updated status",
        domain: "some updated domain",
        slug: "some updated slug",
        schema_name: "some updated schema_name",
        is_active: false
      }

      assert {:ok, %Tenant{} = tenant} = Tenants.update_tenant(scope, tenant, update_attrs)
      assert tenant.name == "some updated name"
      assert tenant.status == "some updated status"
      assert tenant.domain == "some updated domain"
      assert tenant.slug == "some updated slug"
      assert tenant.schema_name == "some updated schema_name"
      assert tenant.is_active == false
    end

    test "update_tenant/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tenant = tenant_fixture(scope)

      assert_raise MatchError, fn ->
        Tenants.update_tenant(other_scope, tenant, %{})
      end
    end

    test "update_tenant/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      tenant = tenant_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Tenants.update_tenant(scope, tenant, @invalid_attrs)
      assert tenant == Tenants.get_tenant!(scope, tenant.id)
    end

    test "delete_tenant/2 deletes the tenant" do
      scope = user_scope_fixture()
      tenant = tenant_fixture(scope)
      assert {:ok, %Tenant{}} = Tenants.delete_tenant(scope, tenant)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_tenant!(scope, tenant.id) end
    end

    test "delete_tenant/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tenant = tenant_fixture(scope)
      assert_raise MatchError, fn -> Tenants.delete_tenant(other_scope, tenant) end
    end

    test "change_tenant/2 returns a tenant changeset" do
      scope = user_scope_fixture()
      tenant = tenant_fixture(scope)
      assert %Ecto.Changeset{} = Tenants.change_tenant(scope, tenant)
    end
  end

  describe "tenant_onboarding" do
    alias BinduBackend.Tenants.TenantOnboarding

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.TenantsFixtures

    @invalid_attrs %{
      current_step: nil,
      is_completed: nil,
      account_created: nil,
      plan_selected: nil,
      restaurant_created: nil,
      menu_configured: nil,
      staff_invited: nil,
      payment_configured: nil,
      inventory_setup: nil,
      completed_at: nil
    }

    test "list_tenant_onboarding/1 returns all scoped tenant_onboarding" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)
      other_tenant_onboarding = tenant_onboarding_fixture(other_scope)
      assert Tenants.list_tenant_onboarding(scope) == [tenant_onboarding]
      assert Tenants.list_tenant_onboarding(other_scope) == [other_tenant_onboarding]
    end

    test "get_tenant_onboarding!/2 returns the tenant_onboarding with given id" do
      scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)
      other_scope = user_scope_fixture()
      assert Tenants.get_tenant_onboarding!(scope, tenant_onboarding.id) == tenant_onboarding

      assert_raise Ecto.NoResultsError, fn ->
        Tenants.get_tenant_onboarding!(other_scope, tenant_onboarding.id)
      end
    end

    test "create_tenant_onboarding/2 with valid data creates a tenant_onboarding" do
      valid_attrs = %{
        current_step: "some current_step",
        is_completed: true,
        account_created: true,
        plan_selected: true,
        restaurant_created: true,
        menu_configured: true,
        staff_invited: true,
        payment_configured: true,
        inventory_setup: true,
        completed_at: ~T[14:00:00]
      }

      scope = user_scope_fixture()

      assert {:ok, %TenantOnboarding{} = tenant_onboarding} =
               Tenants.create_tenant_onboarding(scope, valid_attrs)

      assert tenant_onboarding.current_step == "some current_step"
      assert tenant_onboarding.is_completed == true
      assert tenant_onboarding.account_created == true
      assert tenant_onboarding.plan_selected == true
      assert tenant_onboarding.restaurant_created == true
      assert tenant_onboarding.menu_configured == true
      assert tenant_onboarding.staff_invited == true
      assert tenant_onboarding.payment_configured == true
      assert tenant_onboarding.inventory_setup == true
      assert tenant_onboarding.completed_at == ~T[14:00:00]
      assert tenant_onboarding.user_id == scope.user.id
    end

    test "create_tenant_onboarding/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.create_tenant_onboarding(scope, @invalid_attrs)
    end

    test "update_tenant_onboarding/3 with valid data updates the tenant_onboarding" do
      scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)

      update_attrs = %{
        current_step: "some updated current_step",
        is_completed: false,
        account_created: false,
        plan_selected: false,
        restaurant_created: false,
        menu_configured: false,
        staff_invited: false,
        payment_configured: false,
        inventory_setup: false,
        completed_at: ~T[15:01:01]
      }

      assert {:ok, %TenantOnboarding{} = tenant_onboarding} =
               Tenants.update_tenant_onboarding(scope, tenant_onboarding, update_attrs)

      assert tenant_onboarding.current_step == "some updated current_step"
      assert tenant_onboarding.is_completed == false
      assert tenant_onboarding.account_created == false
      assert tenant_onboarding.plan_selected == false
      assert tenant_onboarding.restaurant_created == false
      assert tenant_onboarding.menu_configured == false
      assert tenant_onboarding.staff_invited == false
      assert tenant_onboarding.payment_configured == false
      assert tenant_onboarding.inventory_setup == false
      assert tenant_onboarding.completed_at == ~T[15:01:01]
    end

    test "update_tenant_onboarding/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)

      assert_raise MatchError, fn ->
        Tenants.update_tenant_onboarding(other_scope, tenant_onboarding, %{})
      end
    end

    test "update_tenant_onboarding/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Tenants.update_tenant_onboarding(scope, tenant_onboarding, @invalid_attrs)

      assert tenant_onboarding == Tenants.get_tenant_onboarding!(scope, tenant_onboarding.id)
    end

    test "delete_tenant_onboarding/2 deletes the tenant_onboarding" do
      scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)

      assert {:ok, %TenantOnboarding{}} =
               Tenants.delete_tenant_onboarding(scope, tenant_onboarding)

      assert_raise Ecto.NoResultsError, fn ->
        Tenants.get_tenant_onboarding!(scope, tenant_onboarding.id)
      end
    end

    test "delete_tenant_onboarding/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)

      assert_raise MatchError, fn ->
        Tenants.delete_tenant_onboarding(other_scope, tenant_onboarding)
      end
    end

    test "change_tenant_onboarding/2 returns a tenant_onboarding changeset" do
      scope = user_scope_fixture()
      tenant_onboarding = tenant_onboarding_fixture(scope)
      assert %Ecto.Changeset{} = Tenants.change_tenant_onboarding(scope, tenant_onboarding)
    end
  end
end
