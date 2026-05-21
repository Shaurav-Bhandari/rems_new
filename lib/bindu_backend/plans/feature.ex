# lib/bindu_backend/billing/feature.ex
defmodule BinduBackend.Billing.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "features" do
    field :name, :string
    field :display_name, :string
    field :description, :string
    field :category, :string
    field :is_active, :boolean, default: true

    many_to_many :plans, BinduBackend.Plans.Plan, join_through: BinduBackend.Plans.Plan_Feature

    timestamps(type: :utc_datetime)
  end

  def changeset(feature, attrs) do
    feature
    |> cast(attrs, [:name, :display_name, :description, :category, :is_active])
    |> validate_required([:name, :display_name])
    |> unique_constraint(:name)
  end
end
