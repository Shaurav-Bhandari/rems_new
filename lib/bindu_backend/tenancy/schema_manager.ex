# lib/bindu_backend/tenancy/schema_manager.ex

defmodule BinduBackend.Tenancy.SchemaManager do
  require Logger

  alias BinduBackend.Repo

  @doc """
  Idempotent: creates the Postgres schema for the tenant slug.
  Safe to call on retry — skips if already exists.
  """
  def create_schema(slug) do
    case Triplex.create(slug, Repo) do
      {:ok, _} ->
        Logger.info("[SchemaManager] Created schema: #{slug}")
        {:ok, :created}

      {:error, %{postgres: %{code: :duplicate_schema}}} ->
        Logger.info("[SchemaManager] Schema already exists (idempotent): #{slug}")
        {:ok, :already_existed}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Runs all pending tenant migrations against the tenant's schema.
  Triplex.migrate is idempotent — already-run migrations are skipped.
  """
  def run_migrations(slug) do
    case Triplex.migrate(slug, Repo) do
      {:ok, _, _} ->
        Logger.info("[SchemaManager] Migrations complete for: #{slug}")
        {:ok, :migrated}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Full rollback: drops the tenant schema entirely.
  Only called from admin tooling, never from the retry path.
  """
  def drop_schema(slug) do
    case Triplex.drop(slug, Repo) do
      {:ok, _} ->
        Logger.info("[SchemaManager] Dropped schema: #{slug}")
        {:ok, :dropped}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Re-run migrations on an existing tenant — useful for platform upgrades.
  """
  def migrate_existing_tenant(slug) do
    run_migrations(slug)
  end

  @doc """
  Migrate ALL active tenants — run during a platform deployment.
  """
  def migrate_all_tenants do
    alias BinduBackend.Public.Tenant
    alias BinduBackend.Repo
    import Ecto.Query

    tenants =
      Tenant
      |> where([t], t.status == :active)
      |> Repo.all()

    results =
      Enum.map(tenants, fn tenant ->
        {tenant.slug, run_migrations(tenant.slug)}
      end)

    failed = Enum.filter(results, fn {_, result} -> match?({:error, _}, result) end)

    if failed == [] do
      {:ok, length(results)}
    else
      {:partial_failure, failed}
    end
  end
end
