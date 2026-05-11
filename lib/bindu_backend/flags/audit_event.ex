# lib/bindu_backend/flags/audit_event.ex
defmodule BinduBackend.Flags.AuditEvent do
  alias ElixirLS.LanguageServer.Plugins.Ecto
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "audit_events" do
    field :name, :string
    field :description, :string
    field :is_system, :boolean, default: true
    field :is_active, :boolean, default: true
    timestamps(type: :utc_datetime)
  end

  def changeset(audit_event, attrs) do
    audit_event
    |> cast(attrs, [:name, :description, :is_system, :is_active])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
