# lib/bindu_backend/restaurant/table_group.ex
defmodule BinduBackend.Restaurant.TableGroup do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "table_groups" do
    field :name, :string, default: ""

    has_many :table_group_items, BinduBackend.Restaurant.TableGroupItem
    has_many :restaurant_tables, through: [:table_group_items, :restaurant_table]

    timestamps(type: :utc_datetime)
  end

  def changeset(table_group, attrs) do
    table_group
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
