defmodule BinduBackend.Repo.TenantMigrations.CreateOrderGroups do
  use Ecto.Migration

  def change do
    create table(:order_groups, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :group_name, :string, null: false
      add :sub_total, :float, default: 0.0, null: false
      add :is_paid, :boolean, default: false, null: false
      add :paid_at, :utc_datetime
      add :order_id, references(:orders, type: :uuid, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:order_groups, [:order_id])
  end
end

