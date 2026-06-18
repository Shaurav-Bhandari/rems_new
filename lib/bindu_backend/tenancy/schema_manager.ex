# lib/bindu_backend/tenancy/schema_manager.ex

defmodule BinduBackend.Tenancy.SchemaManager do
  require Logger

  alias BinduBackend.Repo

  @doc """
  Idempotent: creates the Postgres schema for the tenant slug.
  Safe to call on retry — skips if already exists.
  """
  def create_schema(slug) do
    schema_name = "tenant_#{slug}"

    case Ecto.Adapters.SQL.query(Repo, "CREATE SCHEMA IF NOT EXISTS #{schema_name}", []) do
      {:ok, _} ->
        Logger.info("[SchemaManager] Created schema: #{schema_name}")
        {:ok, :created}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Runs all pending tenant migrations against the tenant's schema.
  Triplex.migrate is idempotent — already-run migrations are skipped.
  """
  def run_migrations(slug) do
    schema_name = "tenant_#{slug}"
    migrations_path = Application.app_dir(:bindu_backend, "priv/repo/tenant_migrations")

    task =
      Task.Supervisor.async_nolink(
        BinduBackend.TaskSupervisor,
        fn ->
          Ecto.Migrator.run(
            Repo,
            migrations_path,
            :up,
            all: true,
            prefix: schema_name,
            dynamic_repo: Repo
          )
        end
      )

    case Task.await(task, 60_000) do
      migrations when is_list(migrations) ->
        Logger.info("[SchemaManager] Migrations complete for: #{schema_name}")
        {:ok, :migrated}

      {:error, reason} ->
        {:error, reason}

      error ->
        {:error, inspect(error)}
    end
  end

  @doc """
  Full rollback: drops the tenant schema entirely.
  Only called from admin tooling, never from the retry path.
  """
  def drop_schema(slug) do
    schema_name = "tenant_#{slug}"

    case Ecto.Adapters.SQL.query(Repo, "DROP SCHEMA IF EXISTS #{schema_name} CASCADE", []) do
      {:ok, _} ->
        Logger.info("[SchemaManager] Dropped schema: #{schema_name}")
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
    import Ecto.Query
    alias BinduBackend.Tenants.Tenant
    alias BinduBackend.Repo

    tenants =
      Tenant
      |> where([t], t.status == "active")
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
