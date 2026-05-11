# lib/bindu_backend/restaurant/restaurant_table.ex
defmodule BinduBackend.Restaurant.RestaurantTable do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "restaurant_tables" do
    field :table_number, :integer
    field :capacity, :integer, default: 0
    field :table_shape, :string, default: "rectangle"
    field :display_order, :integer
    field :is_mergeable, :boolean, default: false

    belongs_to :area, BinduBackend.Restaurant.Area
    belongs_to :status, BinduBackend.Flags.TableStatus, foreign_key: :status_id

    has_many :table_group_items, BinduBackend.Restaurant.TableGroupItem
    has_many :table_groups, through: [:table_group_items, :table_group]
    has_many :table_reservations, BinduBackend.Restaurant.TableReservation
    has_many :orders, BinduBackend.Orders.Order

    timestamps(type: :utc_datetime)
  end

  def changeset(table, attrs) do
    table
    |> cast(attrs, [:table_number, :capacity, :table_shape, :display_order, :is_mergeable, :area_id, :status_id])
    |> validate_required([:table_number, :capacity, :area_id, :status_id])
    |> validate_number(:capacity, greater_than_or_equal_to: 0)
    |> validate_number(:table_number, greater_than: 0)
    |> validate_inclusion(:table_shape, ["rectangle", "circle", "square"])
    |> unique_constraint([:area_id, :table_number])
    |> foreign_key_constraint(:area_id)
    |> foreign_key_constraint(:status_id)
  end
end
