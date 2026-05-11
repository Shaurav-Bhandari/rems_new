# lib/bindu_backend/audit/activity_log.ex
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
    field :timestamp, :utc_datetime

    belongs_to :user, BinduBackend.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(log, attrs) do
    log
    |> cast(attrs, [:action, :entity_name, :entity_id, :details, :timestamp, :user_id])
    |> validate_required([:action, :timestamp])
    |> foreign_key_constraint(:user_id)
  end
end
