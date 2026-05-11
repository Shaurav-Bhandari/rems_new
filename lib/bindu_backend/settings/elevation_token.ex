# lib/bindu_backend/settings/elevation_token.ex
defmodule BinduBackend.Settings.ElevationToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "elevation_tokens" do
    field :token_hash, :string, redact: true
    field :permission, :string
    field :expires_at, :utc_datetime
    field :is_used, :boolean, default: false
    field :used_at, :utc_datetime
    field :request_reason, :string
    field :discount_amount, :decimal
    field :ip_address, :string
    field :device_id, :string

    belongs_to :user, BinduBackend.Accounts.User
    belongs_to :manager, BinduBackend.Accounts.User, foreign_key: :manager_id
    belongs_to :order, BinduBackend.Orders.Order

    timestamps(type: :utc_datetime)
  end

  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token_hash, :permission, :expires_at, :is_used,
        :used_at, :request_reason, :discount_amount,
        :ip_address, :device_id, :user_id, :manager_id, :order_id])
    |> validate_required([:token_hash, :permission, :expires_at, :user_id, :manager_id])
    |> unique_constraint(:token_hash)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:manager_id)
    |> foreign_key_constraint(:order_id)
  end

  def use_changeset(token) do
    now = DateTime.utc_now(:second)
    cast(token, %{is_used: true, used_at: now}, [:is_used, :used_at])
  end

  def expired?(%__MODULE__{expires_at: expires_at}) do
    DateTime.compare(DateTime.utc_now(), expires_at) == :gt
  end
end
