# lib/bindu_backend/tenancy/tenant_provisioner.ex

defmodule BinduBackend.Tenancy.TenantProvisioner do
  require Logger

  alias BinduBackend.Repo
  alias BinduBackend.Public.Tenant
  alias BinduBackend.Tenancy.{SchemaManager, TenantSeeder}

  @steps [
    :create_schema,
    :run_migrations,
    :seed_lookups,
    :seed_roles_and_permissions,
    :seed_admin_user,
    :activate_tenant
  ]

  def provision(%Tenant{} = tenant) do
    Logger.info("[TenantProvisioner] Provisioning #{tenant.slug}")

    Enum.reduce_while(@steps, {:ok, %{}}, fn step, {:ok, acc} ->
      Logger.info("[TenantProvisioner] Step: #{step}")

      case run_step(step, tenant, acc) do
        {:ok, result} ->
          {:cont, {:ok, Map.put(acc, step, result)}}

        {:error, reason} ->
          {:halt, {:error, step, reason}}
      end
    end)
  end

  # ── Step implementations ──────────────────────────────────────────────────

  defp run_step(:create_schema, tenant, _acc),
    do: SchemaManager.create_schema(tenant.slug)

  defp run_step(:run_migrations, tenant, _acc),
    do: SchemaManager.run_migrations(tenant.slug)

  defp run_step(:seed_lookups, tenant, _acc),
    do: TenantSeeder.seed_lookups(tenant.slug)

  defp run_step(:seed_roles_and_permissions, tenant, _acc),
    do: TenantSeeder.seed_roles_and_permissions(tenant.slug)

  defp run_step(:seed_admin_user, tenant, _acc),
    do: TenantSeeder.seed_admin_user(tenant)

  defp run_step(:activate_tenant, tenant, _acc) do
    tenant
    |> Tenant.status_changeset(%{status: :active, activated_at: DateTime.utc_now()})
    |> Repo.update()
  end
end
