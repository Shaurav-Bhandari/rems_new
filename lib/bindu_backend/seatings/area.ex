# lib/bindu_backend/restaurant/area.ex
defmodule BinduBackend.Restaurant.Area do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "areas" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :display_order, :integer

    belongs_to :floor, BinduBackend.Seatings.Floor
    has_many :restaurant_tables, BinduBackend.Restaurant.RestaurantTable

    timestamps(type: :utc_datetime)
  end

  def changeset(area, attrs) do
    area
    |> cast(attrs, [:name, :code, :description, :display_order, :floor_id])
    |> validate_required([:name, :floor_id])
    |> foreign_key_constraint(:floor_id)
  end
end
