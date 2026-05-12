defmodule BinduBackend.TenantsTest do
  use BinduBackend.DataCase

  alias BinduBackend.Tenants

  describe "tenants" do
    alias BinduBackend.Tenants.Tenant

    import BinduBackend.AccountsFixtures, only: [user_scope_fixture: 0]
    import BinduBackend.TenantsFixtures

    @invalid_attrs %{name: nil, status: nil, domain: nil, slug: nil, schema_name: nil, is_active: nil}

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
      valid_attrs = %{name: "some name", status: "some status", domain: "some domain", slug: "some slug", schema_name: "some schema_name", is_active: true}
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
      update_attrs = %{name: "some updated name", status: "some updated status", domain: "some updated domain", slug: "some updated slug", schema_name: "some updated schema_name", is_active: false}

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
end
