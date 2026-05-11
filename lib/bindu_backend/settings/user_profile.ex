# lib/bindu_backend/settings/user_profile.ex
defmodule BinduBackend.Settings.UserProfile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @valid_profile_types ~w(owner manager shift_lead staff)
  @valid_employment_statuses ~w(active terminated suspended)
  @valid_shifts ~w(morning afternoon evening night rotating)

  schema "user_profiles" do
    field :profile_type, :string
    field :role_level, :integer, default: 1
    field :employee_number, :string
    field :department, :string
    field :job_title, :string
    field :hire_date, :date
    field :termination_date, :date
    field :employment_status, :string, default: "active"
    field :hourly_rate, :decimal
    field :monthly_salary, :decimal
    field :commission_rate, :decimal
    field :shift_pattern, :string
    field :default_shift, :string
    field :weekly_hours, :integer, default: 40
    field :can_login_offsite, :boolean, default: false
    field :requires_pin_for_actions, :boolean, default: false
    field :manager_pin, :string, redact: true
    field :temporary_elevation, :boolean, default: false
    field :elevation_expires_at, :utc_datetime
    field :elevation_reason, :string
    field :total_orders_processed, :integer, default: 0
    field :average_order_value, :decimal, default: 0.0
    field :last_performance_review, :utc_datetime
    field :performance_rating, :decimal
    field :preferred_language, :string, default: "en"
    field :notification_preferences, :map, default: %{}
    field :notes, :string

    belongs_to :user, BinduBackend.Accounts.User
    belongs_to :elevation_granted_by, BinduBackend.Accounts.User,
      foreign_key: :elevation_granted_by_id

    timestamps(type: :utc_datetime)
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :profile_type, :role_level, :employee_number, :department,
      :job_title, :hire_date, :termination_date, :employment_status,
      :hourly_rate, :monthly_salary, :commission_rate,
      :shift_pattern, :default_shift, :weekly_hours,
      :can_login_offsite, :requires_pin_for_actions, :manager_pin,
      :temporary_elevation, :elevation_expires_at, :elevation_reason,
      :elevation_granted_by_id, :total_orders_processed, :average_order_value,
      :last_performance_review, :performance_rating,
      :preferred_language, :notification_preferences, :notes, :user_id
    ])
    |> validate_required([:profile_type, :role_level, :user_id])
    |> validate_inclusion(:profile_type, @valid_profile_types)
    |> validate_inclusion(:employment_status, @valid_employment_statuses)
    |> validate_inclusion(:default_shift, @valid_shifts)
    |> validate_number(:role_level, greater_than_or_equal_to: 1)
    |> validate_number(:performance_rating, greater_than_or_equal_to: 0, less_than_or_equal_to: 5)
    |> unique_constraint(:user_id)
    |> unique_constraint(:employee_number)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:elevation_granted_by_id)
  end

  def elevation_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:temporary_elevation, :elevation_expires_at, :elevation_reason, :elevation_granted_by_id])
    |> validate_required([:elevation_expires_at, :elevation_granted_by_id])
  end

  def pin_changeset(profile, pin) do
    profile
    |> cast(%{manager_pin: pin}, [:manager_pin])
    |> validate_required([:manager_pin])
    |> validate_length(:manager_pin, min: 4, max: 4, message: "PIN must be 4 digits")
    |> validate_format(:manager_pin, ~r/^\d{4}$/, message: "PIN must be numeric")
    |> put_change(:manager_pin, Pbkdf2.hash_pwd_salt(pin))
  end
end
