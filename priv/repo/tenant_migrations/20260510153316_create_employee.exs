defmodule BinduBackend.Repo.TenantMigrations.CreateEmployee do
  use Ecto.Migration

  def change do
    create table(:employees, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :user_id, references(:users, type: :uuid, on_delete: :restrict)
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false, unique: true
      add :phone, :string
      add :position, :text
      add :profile_image_url, :text
      add :department, :string
      add :rate, :decimal, null: false
      add :rate_type, references(:rate_types, type: :uuid, on_delete: :restrict)
      add :is_active, :boolean, default: false, null: true
      add :hire_date, :date
      add :termination_date, :date

      timestamps(type: :utc_datetime)
    end

    create unique_index(:employees, [:email])
    create index(:employees, [:user_id])
    create index(:employees, [:department])


    create table(:employee_expenses, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :employee_id, references(:employees, type: :uuid, on_delete: :delete_all), null: false
      add :amount, :decimal, null: false
      add :expense_type, :string, null: false  # "advance", "reimbursement", "bonus", "deduction"
      add :description, :text
      add :expense_date, :date, null: false
      add :is_approved, :boolean, default: false
      add :approved_by_id, references(:users, type: :uuid, on_delete: :restrict)

      timestamps(type: :utc_datetime)

    end
    create index(:employee_expenses, [:employee_id])
    create index(:employee_expenses, [:expense_date])
    create index(:employee_expenses, [:expense_type])

  end
end

