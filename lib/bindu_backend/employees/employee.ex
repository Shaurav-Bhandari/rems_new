defmodule BinduBackend.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type  Ecto.UUID
  schema "employees" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :phone, :string
    field :position, :string
    field :profile_image_url, :string
    field :department, :string
    field :rate, :decimal, null: false
    field :rate_type, :string
    field :is_active, :boolean, default: true
    field :hire_date, :date
    field :termination_date, :date
    belongs_to :user, BinduBackend.Accounts.User


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [
      :first_name, :last_name, :email, :phone,
      :position, :profile_image_url, :department,
      :rate, :rate_type, :is_active,
      :hire_date, :termination_date, :user_id
    ])
    |> validate_required([:first_name, :last_name, :email, :hire_date, :user_id])
    |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/, message: "invalid email format")
    |> validate_number(:rate, greater_than_or_equal_to: 0)
    |> validate_inclusion(:rate_type, ["hourly", "daily", "monthly", "yearly"])
    |> unique_constraint(:email)
    |> foreign_key_constraint(:user_id)
  end
end
