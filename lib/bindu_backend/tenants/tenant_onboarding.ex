defmodule BinduBackend.Tenants.TenantOnboarding do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tenant_onboarding" do
    field :current_step, :string
    field :is_completed, :boolean, default: false
    field :account_created, :boolean, default: false
    field :plan_selected, :boolean, default: false
    field :restaurant_created, :boolean, default: false
    field :menu_configured, :boolean, default: false
    field :staff_invited, :boolean, default: false
    field :payment_configured, :boolean, default: false
    field :inventory_setup, :boolean, default: false
    field :completed_at, :time
    field :account_id, Ecto.UUID

    timestamps(type: :utc_datetime)

    belongs_to :tenant, BinduBackend.Tenants.Tenant, type: Ecto.UUID
  end

  @doc false
  def changeset(tenant, attrs, user_scope) do
    tenant
    |> cast(attrs, [
      :current_step,
      :is_completed,
      :account_created,
      :plan_selected,
      :restaurant_created,
      :menu_configured,
      :staff_invited,
      :payment_configured,
      :inventory_setup,
      :completed_at
    ])
    |> validate_required([
      :current_step,
      :is_completed,
      :account_created,
      :plan_selected,
      :restaurant_created,
      :menu_configured,
      :staff_invited,
      :payment_configured,
      :inventory_setup,
      :completed_at
    ])
    |> put_change(:account_id, user_scope.user.id)
  end
end
