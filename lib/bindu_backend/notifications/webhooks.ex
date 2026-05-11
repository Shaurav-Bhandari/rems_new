defmodule BinduBackend.Integrations.WebhookIntegration do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @valid_events ~w(
    order.created order.updated order.cancelled
    payment.confirmed payment.failed payment.refunded
    kot.created kot.updated
    table.status_changed
    invoice.created
  )

  schema "webhook_integrations" do
    field :name, :string
    field :url, :string
    field :event_type, :string
    field :secret_token, :string, redact: true
    field :is_active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  def changeset(webhook, attrs) do
    webhook
    |> cast(attrs, [:name, :url, :event_type, :secret_token, :is_active])
    |> validate_required([:name, :url, :event_type])
    |> validate_format(:url, ~r/^https?:\/\/.+/, message: "must be a valid URL")
    |> validate_inclusion(:event_type, @valid_events)
    |> unique_constraint([:url, :event_type])
  end
end
