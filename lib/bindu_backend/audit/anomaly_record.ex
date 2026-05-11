# lib/bindu_backend/audit/anomaly_record.ex
defmodule BinduBackend.Audit.AnomalyRecord do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "anomaly_records" do
    field :description, :string
    field :detected_at, :utc_datetime
    field :anomaly_type, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(record, attrs) do
    record
    |> cast(attrs, [:description, :detected_at, :anomaly_type])
    |> validate_required([:detected_at])
  end
end
