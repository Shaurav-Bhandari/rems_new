defmodule BinduBackend.Repo.Migrations.CreateActivityLogs do
  use Ecto.Migration

  def change do
    create table(:activity_logs, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("uuid_generate_v4()")
      add :action, :string, null: false
      add :entity_name, :string
      add :entity_id, :uuid
      add :details, :text
      add :timestamp, :utc_datetime, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :nilify_all)
      timestamps(type: :utc_datetime)
    end

    create index(:activity_logs, [:user_id])
    create index(:activity_logs, [:entity_name])
    create index(:activity_logs, [:timestamp])
    create index(:activity_logs, [:action])
  end
end
