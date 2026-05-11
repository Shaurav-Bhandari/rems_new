defmodule BinduBackend.Orders.OrderGroup do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "order_groups" do
    field :group_name, :string
    field :order_id, :id

    timestamps(type: :utc_datetime)

    has_many :order_items, BinduBackend.Orders.OrderItem
  end

  @doc false
  def changeset(order_group, attrs) do
    order_group
    |> cast(attrs, [:group_name])
    |> validate_required([:group_name])
  end
end
