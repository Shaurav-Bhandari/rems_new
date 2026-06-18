defmodule BinduBackend.Repo.Migrations.AlterTenantsAddProvisioningFields do
  use Ecto.Migration

  def change do
    alter table(:tenants) do
      add_if_not_exists :owner_email, :citext, null: true
      add_if_not_exists :owner_name, :string, null: true
      add_if_not_exists :status, :string, null: false, default: "pending"
      add_if_not_exists :provisioning_error, :text, null: true
      add_if_not_exists :activated_at, :utc_datetime, null: true
      add_if_not_exists :failed_at, :utc_datetime, null: true
      add_if_not_exists :rolled_back_at, :utc_datetime, null: true
      add_if_not_exists :is_deleted, :boolean, default: false, null: false
    end

    create_if_not_exists index(:tenants, [:status])
    create_if_not_exists index(:tenants, [:owner_email])
  end
end
