# lib/bindu_backend/restaurant/table_group_item.ex
defmodule BinduBackend.Restaurant.TableGroupItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "table_group_items" do
    belongs_to :table_group, BinduBackend.Restaurant.TableGroup
    belongs_to :restaurant_table, BinduBackend.Restaurant.RestaurantTable

    timestamps(type: :utc_datetime)
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:table_group_id, :restaurant_table_id])
    |> validate_required([:table_group_id, :restaurant_table_id])
    |> unique_constraint([:table_group_id, :restaurant_table_id])
    |> foreign_key_constraint(:table_group_id)
    |> foreign_key_constraint(:restaurant_table_id)
  end
end
