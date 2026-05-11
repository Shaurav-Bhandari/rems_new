defmodule BinduBackend.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :text, unique: true, null: false
      add :contact_number, :text
      add :total_orders, :integer
      add :loyalty_points, :integer
      add :total_spent, :float
      add :is_active, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:customers, [:user_id])
  end
end
