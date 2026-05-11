# lib/bindu_backend/flags/notification_type.ex
defmodule BinduBackend.Flags.NotificationType do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "notification_types" do
    field :name, :string
    field :description, :string
    field :is_system, :boolean, default: true
    field :is_active, :boolean, default: true
    timestamps(type: :utc_datetime)
  end

  def changeset(notification_type, attrs) do
    notification_type
    |> cast(attrs, [:name, :description, :is_system, :is_active])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
