defmodule BinduBackend.Notifications.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "notifications" do
    field :message, :string
    field :notification_type, :string
    field :is_read, :boolean, default: false

    belongs_to :user, BinduBackend.Accounts.User, type: :binary_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(notification, attrs, user_scope) do
    notification
    |> cast(attrs, [:message, :notification_type, :is_read])
    |> validate_required([:message, :notification_type, :is_read])
    |> put_change(:user_id, user_scope.user.id)
  end
end
