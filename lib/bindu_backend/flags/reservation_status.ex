# lib/bindu_backend/flags/reservation_status.ex
defmodule BinduBackend.Flags.ReservationStatus do
  use Ecto.Schema
  import Ecto.Changeset


  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "reservation_statuses" do
    field :name, :string
    field :description, :string
    field :is_system, :boolean, default: true
    field :is_active, :boolean, default: true
    timestamps(type: :utc_datetime)
  end

  def changeset(reservation_status, attrs) do
    reservation_status
    |> cast(attrs, [:name, :description, :is_system, :is_active])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
