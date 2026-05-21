defmodule BinduBackend.TenantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.Tenants` context.
  """

  @doc """
  Generate a tenant.
  """
  def tenant_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        domain: "some domain",
        is_active: true,
        name: "some name",
        schema_name: "some schema_name",
        slug: "some slug",
        status: "some status"
      })

    {:ok, tenant} = BinduBackend.Tenants.create_tenant(scope, attrs)
    tenant
  end

  @doc """
  Generate a tenant_onboarding.
  """
  def tenant_onboarding_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        account_created: true,
        completed_at: ~T[14:00:00],
        current_step: "some current_step",
        inventory_setup: true,
        is_completed: true,
        menu_configured: true,
        payment_configured: true,
        plan_selected: true,
        restaurant_created: true,
        staff_invited: true
      })

    {:ok, tenant_onboarding} = BinduBackend.Tenants.create_tenant_onboarding(scope, attrs)
    tenant_onboarding
  end
end
