defmodule BinduBackend.Plans.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :start_date, :date
    field :end_date, :date
    field :status, :string
    field :auto_renew, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subscription, attrs, user_scope) do
    subscription
    |> cast(attrs, [:start_date, :end_date, :status, :auto_renew])
    |> validate_required([:start_date, :end_date, :status, :auto_renew])
    |> put_change(:user_id, user_scope.user.id)
  end
end
