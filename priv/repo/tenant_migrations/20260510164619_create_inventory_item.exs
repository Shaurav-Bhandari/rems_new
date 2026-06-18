defmodule BinduBackend.Repo.TenantMigrations.CreateInventoryItem do
  use Ecto.Migration

  def change do
    create table(:inventory_item) do
      add :name, :text
      add :description, :text
      add :sku, :string
      add :category, :string
      add :measurement_unit, :string
      add :current_quantity, :float
      add :minimum_quantity, :float
      add :maximum_quantity, :float
      add :reorder_point, :float
      add :unit_cost, :float
      add :last_restock_date, :date
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:inventory_item, [:user_id])
  end
end

