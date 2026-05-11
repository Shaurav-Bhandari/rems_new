defmodule BinduBackend.Repo.Migrations.CreateAnomalyRecords do
  use Ecto.Migration

  def change do
    create table(:anomaly_records, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :description, :text
      add :detected_at, :utc_datetime, null: false
      add :anomaly_type, :string
      timestamps(type: :utc_datetime)
    end

    create index(:anomaly_records, [:anomaly_type])
    create index(:anomaly_records, [:detected_at])
  end
end
