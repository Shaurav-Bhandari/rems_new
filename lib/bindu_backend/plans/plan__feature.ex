defmodule BinduBackend.Plans.Plan_Feature do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "plan_features" do
    field :is_enabled, :boolean, default: true
    field :limit_value, :integer

    belongs_to :plan, BinduBackend.Plans.Plan
    belongs_to :feature, BinduBackend.Billing.Feature

    timestamps(type: :utc_datetime)
  end

  def changeset(plan_feature, attrs) do
    plan_feature
    |> cast(attrs, [:is_enabled, :limit_value, :plan_id, :feature_id])
    |> validate_required([:plan_id, :feature_id])
    |> unique_constraint([:plan_id, :feature_id])
    |> foreign_key_constraint(:plan_id)
    |> foreign_key_constraint(:feature_id)
  end
end
