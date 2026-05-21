defmodule BinduBackend.Inventories.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "inventory_item" do
    field :name, :string
    field :description, :string
    field :sku, :string
    field :category, :string
    field :measurement_unit, :string
    field :current_quantity, :float
    field :minimum_quantity, :float
    field :maximum_quantity, :float
    field :reorder_point, :float
    field :unit_cost, :float
    field :last_restock_date, :date
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory, attrs, user_scope) do
    inventory
    |> cast(attrs, [
      :name,
      :description,
      :sku,
      :category,
      :measurement_unit,
      :current_quantity,
      :minimum_quantity,
      :maximum_quantity,
      :reorder_point,
      :unit_cost,
      :last_restock_date
    ])
    |> validate_required([
      :name,
      :description,
      :sku,
      :category,
      :measurement_unit,
      :current_quantity,
      :minimum_quantity,
      :maximum_quantity,
      :reorder_point,
      :unit_cost,
      :last_restock_date
    ])
    |> put_change(:user_id, user_scope.user.id)
  end
end
