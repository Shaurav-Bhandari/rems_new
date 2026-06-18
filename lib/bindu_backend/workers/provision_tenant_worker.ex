# lib/bindu_backend/workers/provision_tenant_worker.ex

defmodule BinduBackend.Workers.ProvisionTenantWorker do
  use Oban.Worker,
    queue: :tenant_provisioning,
    max_attempts: 5,
    # Oban built-in: 15s → 60s → 240s → 960s → 3840s
    unique: [period: 60, fields: [:args]]

  require Logger

  alias BinduBackend.Repo
  alias BinduBackend.Tenancy.TenantProvisioner
  alias BinduBackend.Tenants.Tenant

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"tenant_id" => tenant_id}, attempt: attempt}) do
    Logger.info("[ProvisionTenant] Starting attempt #{attempt} for tenant #{tenant_id}")

    tenant = Repo.get!(Tenant, tenant_id)

    case TenantProvisioner.provision(tenant) do
      {:ok, _} ->
        Logger.info("[ProvisionTenant] Successfully provisioned tenant #{tenant.slug}")
        :ok

      {:error, step, reason} ->
        Logger.error("[ProvisionTenant] Failed at step=#{step} reason=#{inspect(reason)}")
        # Mark as failed only on final attempt — Oban handles the retry scheduling
        maybe_mark_failed(tenant, attempt, step, reason)
        {:error, reason}
    end
  end

  defp maybe_mark_failed(tenant, attempt, step, reason) do
    if attempt >= max_attempts() do
      tenant
      |> Tenant.provisioning_failed_changeset(%{
        status: :failed,
        provisioning_error: "Failed at #{step}: #{inspect(reason)}",
        failed_at: DateTime.utc_now()
      })
      |> Repo.update()

      # Notify super admin
      BinduBackend.Mailer.send_provisioning_failure_alert(
        tenant.id,
        tenant.slug,
        step,
        inspect(reason)
      )
    end
  end

  defp max_attempts, do: 5
end
