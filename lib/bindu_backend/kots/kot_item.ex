# lib/bindu_backend/kot/kot_item.ex
defmodule BinduBackend.Kot.KotItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "kot_items" do
    field :item_name, :string
    field :quantity, :integer
    field :special_instructions, :string

    belongs_to :kot, BinduBackend.Kot.Kot
    belongs_to :order_item, BinduBackend.Orders.OrderItem
    # belongs_to :status, BinduBackend.Flags.KotItemStatus, foreign_key: :status_id

    timestamps(type: :utc_datetime)
  end

  def changeset(kot_item, attrs) do
    kot_item
    |> cast(attrs, [
      :item_name,
      :quantity,
      :special_instructions,
      :kot_id,
      :order_item_id,
      :status_id
    ])
    |> validate_required([:item_name, :quantity, :kot_id, :order_item_id, :status_id])
    |> validate_number(:quantity, greater_than: 0)
    |> foreign_key_constraint(:kot_id)
    |> foreign_key_constraint(:order_item_id)
    |> foreign_key_constraint(:status_id)
  end
end
