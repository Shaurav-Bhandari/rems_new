defmodule BinduBackend.Repo.Migrations.CreatePlans do
  use Ecto.Migration

  def change do
    create table(:plans, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string
      add :description, :text
      add :price, :decimal
      add :billing_cycle, :string
      add :max_restaurants, :integer
      add :max_users, :integer
      add :is_active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :restrict)

      timestamps(type: :utc_datetime)
    end

    create index(:plans, [:user_id])
  end
end
