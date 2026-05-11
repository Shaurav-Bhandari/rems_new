defmodule BinduBackend.Employees.EmployeeExpense do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "employee_expenses" do
    field :amount, :decimal
    field :expense_type, :string
    field :description, :string
    field :expense_date, :date
    field :is_approved, :boolean, default: false

    belongs_to :employee, BinduBackend.Employees.Employee
    belongs_to :approved_by, BinduBackend.Accounts.User, foreign_key: :approved_by_id

    timestamps(type: :utc_datetime)
  end

  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [
      :amount, :expense_type, :description,
      :expense_date, :is_approved,
      :employee_id, :approved_by_id
    ])
    |> validate_required([:amount, :expense_type, :expense_date, :employee_id])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:expense_type, ["advance", "reimbursement", "bonus", "deduction"])
    |> foreign_key_constraint(:employee_id)
    |> foreign_key_constraint(:approved_by_id)
  end
end
