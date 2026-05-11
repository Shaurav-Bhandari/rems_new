# lib/bindu_backend/flags/rule_type.ex
defmodule BinduBackend.Flags.RuleType do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "rule_types" do
    field :name, :string
    field :description, :string
    field :is_system, :boolean, default: true
    field :is_active, :boolean, default: true
    timestamps(type: :utc_datetime)
  end

  def changeset(rule_type, attrs) do
    rule_type
    |> cast(attrs, [:name, :description, :is_system, :is_active])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
