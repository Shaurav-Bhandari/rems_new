defmodule BinduBackend.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @{primary_key {:id, Ecto.UUID, autogenerate: true}}
  @foreign_key_type Ecto.UUID
  schema "customers" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :contact_number, :string
    field :total_orders, :integer
    field :loyalty_points, :integer
    field :total_spent, :float
    field :is_active, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(customer, attrs, user_scope) do
    customer
    |> cast(attrs, [:first_name, :last_name, :email, :contact_number, :total_orders, :loyalty_points, :total_spent, :is_active])
    |> validate_required([:first_name, :last_name, :email, :contact_number, :total_orders, :loyalty_points, :total_spent, :is_active])
    |> put_change(:user_id, user_scope.user.id)
  end
end
