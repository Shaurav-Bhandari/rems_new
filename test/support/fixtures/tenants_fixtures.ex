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
end
