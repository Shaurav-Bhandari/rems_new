defmodule BinduBackend.Audit.ActivityLog do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "activity_logs" do
    field :action, :string
    field :entity_name, :string
    field :entity_id, :binary_id
    field :details, :string

    belongs_to :user, BinduBackend.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(activity_log, attrs) do
    activity_log
    |> cast(attrs, [
      :action,
      :entity_name,
      :entity_id,
      :details,
      :user_id
    ])
    |> validate_required([
      :action,
      :entity_name,
      :user_id
    ])
    |> foreign_key_constraint(:user_id)
  end
end
