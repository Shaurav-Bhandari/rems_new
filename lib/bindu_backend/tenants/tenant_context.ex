defmodule BinduBackend.Tenants.TenantContext do
  import Ecto.Query

  alias BinduBackend.Repo
  alias BinduBackend.Tenants.Tenant
  alias BinduBackend.Workers.ProvisionTenantWorker

  @doc """
  Creates a tenant and enqueues provisioning — both in the same DB transaction.
  If the transaction rolls back, the Oban job is also rolled back automatically.
  """
  def create_tenant(attrs) do
    Repo.transaction(fn ->
      tenant =
        %Tenant{}
        |> Tenant.registration_changeset(attrs)
        |> Repo.insert!()

      %{"tenant_id" => tenant.id}
      |> ProvisionTenantWorker.new()
      |> Oban.insert!()

      tenant
    end)
  end

  def get_tenant!(id), do: Repo.get!(Tenant, id)

  def get_tenant_by_slug(slug) do
    Repo.get_by(Tenant, slug: slug, is_deleted: false)
  end

  def list_tenants do
    Tenant
    |> where([t], t.is_deleted == false)
    |> order_by([t], desc: t.inserted_at)
    |> Repo.all()
  end

  def list_active_tenants do
    Tenant
    |> where([t], t.status == "active" and t.is_deleted == false)
    |> Repo.all()
  end

  @doc """
  Used by TenantRollback to retry a failed tenant.
  Resets status to pending and re-enqueues the provisioning job.
  """
  def retry_provisioning(%Tenant{status: status} = tenant)
      when status in ["failed", "rolled_back"] do
    Repo.transaction(fn ->
      {:ok, tenant} =
        tenant
        |> Tenant.status_changeset(%{status: "pending", provisioning_error: nil})
        |> Repo.update()

      %{"tenant_id" => tenant.id}
      |> ProvisionTenantWorker.new()
      |> Oban.insert!()

      tenant
    end)
  end

  def retry_provisioning(%Tenant{status: status}),
    do: {:error, "Cannot retry a tenant with status: #{status}"}

  def suspend_tenant(%Tenant{} = tenant) do
    tenant
    |> Tenant.status_changeset(%{status: "suspended", is_active: false})
    |> Repo.update()
  end

  def delete_tenant(%Tenant{} = tenant) do
    tenant
    |> Ecto.Changeset.change(%{is_deleted: true, is_active: false})
    |> Repo.update()
  end
end
