defmodule BinduBackend.Seatings.Floor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "floors" do
    field :name, :string
    field :code, :string
    field :description, :string
    field :display_order, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(floor, attrs, user_scope) do
    floor
    |> cast(attrs, [:name, :code, :description, :display_order])
    |> validate_required([:name, :code, :description, :display_order])
    |> put_change(:user_id, user_scope.user.id)
  end
end
