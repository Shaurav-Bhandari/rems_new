defmodule BinduBackend.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    create table(:tenants, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :slug, :text
      add :schema_name, :string
      add :domain, :text
      add :status, :string
      add :is_active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tenants, [:user_id])
  end
end
