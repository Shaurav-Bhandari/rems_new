defmodule BinduBackend.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")

      add :start_date, :date
      add :end_date, :date
      add :status, :string
      add :auto_renew, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:subscriptions, [:user_id])
  end
end
