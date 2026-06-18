defmodule BinduBackend.Tenants.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "tenants" do
    field :name, :string
    field :slug, :string
    field :owner_email, :string
    field :owner_name, :string
    field :owner_account_id, Ecto.UUID
    field :status, :string, default: "pending"
    field :provisioning_error, :string
    field :activated_at, :utc_datetime
    field :failed_at, :utc_datetime
    field :rolled_back_at, :utc_datetime
    field :is_active, :boolean, default: false
    field :is_deleted, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @valid_statuses ~w(pending provisioning active failed rolled_back suspended)

  def registration_changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:name, :slug, :owner_email, :owner_name])
    |> validate_required([:name, :slug, :owner_email, :owner_name])
    |> validate_format(:owner_email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_format(:slug, ~r/^[a-z0-9_]+$/,
      message: "only lowercase letters, numbers and underscores"
    )
    |> validate_length(:slug, min: 3, max: 50)
    |> unique_constraint(:slug)
    |> unique_constraint(:owner_email)
    |> put_change(:status, "pending")
  end

  def status_changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [
      :status,
      :activated_at,
      :failed_at,
      :rolled_back_at,
      :is_active,
      :owner_account_id
    ])
    |> validate_required([:status])
    |> validate_inclusion(:status, @valid_statuses)
  end

  def provisioning_failed_changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:status, :provisioning_error, :failed_at])
    |> validate_required([:status, :provisioning_error])
  end
end
