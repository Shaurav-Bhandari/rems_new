# lib/bindu_backend/tenancy/tenant_rollback.ex

defmodule BinduBackend.Tenancy.TenantRollback do
  require Logger

  alias BinduBackend.Repo
  alias BinduBackend.Tenants.Tenant
  alias BinduBackend.Tenancy.SchemaManager

  @doc """
  Full teardown: drop schema + mark tenant as rolled_back.
  Only callable by a super admin on a :failed tenant.
  """
  def rollback_tenant(%Tenant{status: :failed} = tenant) do
    Logger.warning("[TenantRollback] Rolling back tenant: #{tenant.slug}")

    with {:ok, _} <- SchemaManager.drop_schema(tenant.slug),
         {:ok, tenant} <- mark_rolled_back(tenant) do
      Logger.info("[TenantRollback] Rollback complete for #{tenant.slug}")
      {:ok, tenant}
    end
  end

  def rollback_tenant(%Tenant{status: status}),
    do: {:error, "Cannot rollback a tenant with status: #{status}"}

  @doc """
  Retry provisioning a failed tenant — resets status to :pending
  and re-enqueues the Oban job.
  """
  def retry_provisioning(%Tenant{status: status} = tenant)
      when status in [:failed, :rolled_back] do
    with {:ok, tenant} <-
           tenant
           |> Tenant.status_changeset(%{status: :pending, provisioning_error: nil})
           |> Repo.update() do
      %{"tenant_id" => tenant.id}
      |> BinduBackend.Workers.ProvisionTenantWorker.new()
      |> Oban.insert()

      {:ok, tenant}
    end
  end

  defp mark_rolled_back(tenant) do
    tenant
    |> Tenant.status_changeset(%{status: :rolled_back, rolled_back_at: DateTime.utc_now()})
    |> Repo.update()
  end
end
