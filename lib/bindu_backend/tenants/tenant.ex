defmodule BinduBackend.Tenants.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenants" do
    field :name, :string
    field :slug, :string
    field :schema_name, :string
    field :domain, :string
    field :status, :string
    field :is_active, :boolean, default: false
    field :user_id, :id

    timestamps(type: :utc_datetime)

    has_one :onboarding, BinduBackend.Tenants.TenantOnboarding, on_delete: :delete_all
  end

  @doc false
  def changeset(tenant, attrs, user_scope) do
    tenant
    |> cast(attrs, [:name, :slug, :schema_name, :domain, :status, :is_active])
    |> validate_required([:name, :slug, :schema_name, :domain, :status, :is_active])
    |> put_change(:user_id, user_scope.user.id)
  end
end
