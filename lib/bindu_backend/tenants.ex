defmodule BinduBackend.Tenants do
  @moduledoc """
  The Tenants context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Tenants.Tenant
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any tenant changes.

  The broadcasted messages match the pattern:

    * {:created, %Tenant{}}
    * {:updated, %Tenant{}}
    * {:deleted, %Tenant{}}

  """
  def subscribe_tenants(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:tenants")
  end

  defp broadcast_tenant(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:tenants", message)
  end

  @doc """
  Returns the list of tenants.

  ## Examples

      iex> list_tenants()
      [%Tenant{}, ...]

  """
  def list_tenants do
    Repo.all(Tenant)
  end

  @doc """
  Gets a single tenant.

  Raises `Ecto.NoResultsError` if the Tenant does not exist.

  ## Examples

      iex> get_tenant!(123)
      %SuperAdmin{}

  """
  def get_tenant!(id), do: Repo.get!(Tenant, id)

  @doc """
  Creates a tenant.

  ## Examples

      iex> create_tenant(%{field: value})
      {:ok, %Tenant{}}

      iex> create_tenant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tenant(attrs) do
    %Tenant{}
    |> Tenant.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tenant.

  ## Examples

      iex> update_tenant(tenant, %{field: new_value})
      {:ok, %Tenant{}}

      iex> update_tenant(tenant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tenant(%Tenant{} = tenant, attrs) do
    tenant
    |> Tenant.status_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tenant.

  ## Examples

      iex> delete_tenant(tenant)
      {:ok, %Tenant{}}

      iex> delete_tenant(tenant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tenant(%Tenant{} = tenant) do
    tenant
    |> Ecto.Changeset.change(%{is_deleted: true, is_active: false})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tenant changes.

  ## Examples

      iex> change_tenant(tenant)
      %Ecto.Changeset{data: %Tenant{}}

  """
  def change_tenant(%Tenant{} = tenant, attrs \\ %{}) do
    Tenant.registration_changeset(tenant, attrs)
  end

  alias BinduBackend.Tenants.TenantOnboarding
  alias BinduBackend.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any tenant_onboarding changes.

  The broadcasted messages match the pattern:

    * {:created, %TenantOnboarding{}}
    * {:updated, %TenantOnboarding{}}
    * {:deleted, %TenantOnboarding{}}

  """
  def subscribe_tenant_onboarding(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BinduBackend.PubSub, "user:#{key}:tenant_onboarding")
  end

  defp broadcast_tenant_onboarding(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BinduBackend.PubSub, "user:#{key}:tenant_onboarding", message)
  end

  @doc """
  Returns the list of tenant_onboarding.

  ## Examples

      iex> list_tenant_onboarding(scope)
      [%TenantOnboarding{}, ...]

  """
  def list_tenant_onboarding(%Scope{} = scope) do
    Repo.all_by(TenantOnboarding, user_id: scope.user.id)
  end

  @doc """
  Gets a single tenant_onboarding.

  Raises `Ecto.NoResultsError` if the TenantOnboarding does not exist.

  ## Examples

      iex> get_tenant_onboarding!(scope, 123)
      %TenantOnboarding{}

      iex> get_tenant_onboarding!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_tenant_onboarding!(%Scope{} = scope, id) do
    Repo.get_by!(TenantOnboarding, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a tenant_onboarding.

  ## Examples

      iex> create_tenant_onboarding(scope, %{field: value})
      {:ok, %TenantOnboarding{}}

      iex> create_tenant_onboarding(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tenant_onboarding(%Scope{} = scope, attrs) do
    with {:ok, tenant_onboarding = %TenantOnboarding{}} <-
           %TenantOnboarding{}
           |> TenantOnboarding.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_tenant_onboarding(scope, {:created, tenant_onboarding})
      {:ok, tenant_onboarding}
    end
  end

  @doc """
  Updates a tenant_onboarding.

  ## Examples

      iex> update_tenant_onboarding(scope, tenant_onboarding, %{field: new_value})
      {:ok, %TenantOnboarding{}}

      iex> update_tenant_onboarding(scope, tenant_onboarding, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tenant_onboarding(%Scope{} = scope, %TenantOnboarding{} = tenant_onboarding, attrs) do
    true = tenant_onboarding.user_id == scope.user.id

    with {:ok, tenant_onboarding = %TenantOnboarding{}} <-
           tenant_onboarding
           |> TenantOnboarding.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_tenant_onboarding(scope, {:updated, tenant_onboarding})
      {:ok, tenant_onboarding}
    end
  end

  @doc """
  Deletes a tenant_onboarding.

  ## Examples

      iex> delete_tenant_onboarding(scope, tenant_onboarding)
      {:ok, %TenantOnboarding{}}

      iex> delete_tenant_onboarding(scope, tenant_onboarding)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tenant_onboarding(%Scope{} = scope, %TenantOnboarding{} = tenant_onboarding) do
    true = tenant_onboarding.user_id == scope.user.id

    with {:ok, tenant_onboarding = %TenantOnboarding{}} <-
           Repo.delete(tenant_onboarding) do
      broadcast_tenant_onboarding(scope, {:deleted, tenant_onboarding})
      {:ok, tenant_onboarding}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tenant_onboarding changes.

  ## Examples

      iex> change_tenant_onboarding(scope, tenant_onboarding)
      %Ecto.Changeset{data: %TenantOnboarding{}}

  """
  def change_tenant_onboarding(
        %Scope{} = scope,
        %TenantOnboarding{} = tenant_onboarding,
        attrs \\ %{}
      ) do
    true = tenant_onboarding.user_id == scope.user.id

    TenantOnboarding.changeset(tenant_onboarding, attrs, scope)
  end
end
