defmodule BinduBackend.Workers.ProvisionTenantWorker do
  use Oban.Worker, queue: :tenant_provisioning, max_attempts: 5

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"tenant_id" => _tenant_id}}) do
    # Dummy implementation since TenantProvisioner is not present in rems_new
    :ok
  end
end
