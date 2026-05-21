defmodule BinduBackend.Plans.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "plans" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :billing_cycle, :string
    field :max_restaurants, :integer
    field :max_users, :integer
    field :is_active, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)

    many_to_many :features, BinduBackend.Billing.Feature,
      join_through: BinduBackend.Plans.Plan_Feature
  end

  @doc false
  def changeset(plan, attrs, user_scope) do
    plan
    |> cast(attrs, [
      :name,
      :description,
      :price,
      :billing_cycle,
      :max_restaurants,
      :max_users,
      :is_active
    ])
    |> validate_required([
      :name,
      :description,
      :price,
      :billing_cycle,
      :max_restaurants,
      :max_users,
      :is_active
    ])
    |> put_change(:user_id, user_scope.user.id)
  end
end
