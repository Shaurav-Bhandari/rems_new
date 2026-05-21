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
    field :status, :string, default: "pending"
    field :is_active, :boolean, default: false

    # ✅ binary_id to match User's Ecto.UUID primary key
    belongs_to :user, BinduBackend.Accounts.User, type: :binary_id

    has_one :onboarding, BinduBackend.Tenants.TenantOnboarding, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  def changeset(tenant, attrs, user_scope) do
    tenant
    |> cast(attrs, [:name, :slug, :schema_name, :domain, :status, :is_active])
    |> validate_required([:name, :slug, :schema_name, :domain, :status])
    |> validate_format(:slug, ~r/^[a-z0-9_]+$/,
      message: "only lowercase letters, numbers, underscores"
    )
    |> validate_inclusion(:status, ["pending", "active", "suspended"])
    |> unique_constraint(:slug)
    |> unique_constraint(:schema_name)
    |> unique_constraint(:domain)
    |> put_change(:user_id, user_scope.user.id)
  end
end
