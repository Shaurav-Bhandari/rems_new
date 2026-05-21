# lib/bindu_backend/restaurant/table_reservation.ex
defmodule BinduBackend.Restaurant.TableReservation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "table_reservations" do
    field :customer_name, :string
    field :customer_contact, :string
    field :reservation_time, :utc_datetime
    field :number_of_people, :integer
    field :notes, :string

    belongs_to :restaurant_table, BinduBackend.Restaurant.RestaurantTable
    belongs_to :status, BinduBackend.Flags.ReservationStatus, foreign_key: :status_id

    timestamps(type: :utc_datetime)
  end

  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [
      :customer_name,
      :customer_contact,
      :reservation_time,
      :number_of_people,
      :notes,
      :restaurant_table_id,
      :status_id
    ])
    |> validate_required([:reservation_time, :restaurant_table_id, :status_id])
    |> validate_number(:number_of_people, greater_than: 0)
    |> foreign_key_constraint(:restaurant_table_id)
    |> foreign_key_constraint(:status_id)
  end
end
