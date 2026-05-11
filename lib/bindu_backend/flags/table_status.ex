defmodule BinduBackend.Flags.TableStatus do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "table_statuses" do
    field :name, :string
    field :description, :string
    field :is_default, :boolean, default: false
    field :is_system, :boolean, default: true
    field :is_active, :boolean, default: true
    timestamps(type: :utc_datetime)
  end

  def changeset(table_status, attrs) do
    table_status
    |> cast(attrs, [:name, :description, :is_default, :is_system, :is_active])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
