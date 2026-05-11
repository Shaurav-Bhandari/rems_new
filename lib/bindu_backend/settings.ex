defmodule BinduBackend.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.Settings.TenantSetting

  @doc """
  Returns the list of tenant_settings.

  ## Examples

      iex> list_tenant_settings()
      [%TenantSetting{}, ...]

  """
  def list_tenant_settings do
    Repo.all(TenantSetting)
  end

  @doc """
  Gets a single tenant_setting.

  Raises `Ecto.NoResultsError` if the Tenant setting does not exist.

  ## Examples

      iex> get_tenant_setting!(123)
      %TenantSetting{}

      iex> get_tenant_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tenant_setting!(id), do: Repo.get!(TenantSetting, id)

  @doc """
  Creates a tenant_setting.

  ## Examples

      iex> create_tenant_setting(%{field: value})
      {:ok, %TenantSetting{}}

      iex> create_tenant_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tenant_setting(attrs) do
    %TenantSetting{}
    |> TenantSetting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tenant_setting.

  ## Examples

      iex> update_tenant_setting(tenant_setting, %{field: new_value})
      {:ok, %TenantSetting{}}

      iex> update_tenant_setting(tenant_setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tenant_setting(%TenantSetting{} = tenant_setting, attrs) do
    tenant_setting
    |> TenantSetting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tenant_setting.

  ## Examples

      iex> delete_tenant_setting(tenant_setting)
      {:ok, %TenantSetting{}}

      iex> delete_tenant_setting(tenant_setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tenant_setting(%TenantSetting{} = tenant_setting) do
    Repo.delete(tenant_setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tenant_setting changes.

  ## Examples

      iex> change_tenant_setting(tenant_setting)
      %Ecto.Changeset{data: %TenantSetting{}}

  """
  def change_tenant_setting(%TenantSetting{} = tenant_setting, attrs \\ %{}) do
    TenantSetting.changeset(tenant_setting, attrs)
  end

  alias BinduBackend.Settings.RestaurantProfile

  @doc """
  Returns the list of restaurant_profiles.

  ## Examples

      iex> list_restaurant_profiles()
      [%RestaurantProfile{}, ...]

  """
  def list_restaurant_profiles do
    Repo.all(RestaurantProfile)
  end

  @doc """
  Gets a single restaurant_profile.

  Raises `Ecto.NoResultsError` if the Restaurant profile does not exist.

  ## Examples

      iex> get_restaurant_profile!(123)
      %RestaurantProfile{}

      iex> get_restaurant_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_restaurant_profile!(id), do: Repo.get!(RestaurantProfile, id)

  @doc """
  Creates a restaurant_profile.

  ## Examples

      iex> create_restaurant_profile(%{field: value})
      {:ok, %RestaurantProfile{}}

      iex> create_restaurant_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_restaurant_profile(attrs) do
    %RestaurantProfile{}
    |> RestaurantProfile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a restaurant_profile.

  ## Examples

      iex> update_restaurant_profile(restaurant_profile, %{field: new_value})
      {:ok, %RestaurantProfile{}}

      iex> update_restaurant_profile(restaurant_profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_restaurant_profile(%RestaurantProfile{} = restaurant_profile, attrs) do
    restaurant_profile
    |> RestaurantProfile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a restaurant_profile.

  ## Examples

      iex> delete_restaurant_profile(restaurant_profile)
      {:ok, %RestaurantProfile{}}

      iex> delete_restaurant_profile(restaurant_profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_restaurant_profile(%RestaurantProfile{} = restaurant_profile) do
    Repo.delete(restaurant_profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking restaurant_profile changes.

  ## Examples

      iex> change_restaurant_profile(restaurant_profile)
      %Ecto.Changeset{data: %RestaurantProfile{}}

  """
  def change_restaurant_profile(%RestaurantProfile{} = restaurant_profile, attrs \\ %{}) do
    RestaurantProfile.changeset(restaurant_profile, attrs)
  end

  alias BinduBackend.Settings.UserProfile

  @doc """
  Returns the list of user_profiles.

  ## Examples

      iex> list_user_profiles()
      [%UserProfile{}, ...]

  """
  def list_user_profiles do
    Repo.all(UserProfile)
  end

  @doc """
  Gets a single user_profile.

  Raises `Ecto.NoResultsError` if the User profile does not exist.

  ## Examples

      iex> get_user_profile!(123)
      %UserProfile{}

      iex> get_user_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_profile!(id), do: Repo.get!(UserProfile, id)

  @doc """
  Creates a user_profile.

  ## Examples

      iex> create_user_profile(%{field: value})
      {:ok, %UserProfile{}}

      iex> create_user_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_profile(attrs) do
    %UserProfile{}
    |> UserProfile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_profile.

  ## Examples

      iex> update_user_profile(user_profile, %{field: new_value})
      {:ok, %UserProfile{}}

      iex> update_user_profile(user_profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_profile(%UserProfile{} = user_profile, attrs) do
    user_profile
    |> UserProfile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_profile.

  ## Examples

      iex> delete_user_profile(user_profile)
      {:ok, %UserProfile{}}

      iex> delete_user_profile(user_profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_profile(%UserProfile{} = user_profile) do
    Repo.delete(user_profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_profile changes.

  ## Examples

      iex> change_user_profile(user_profile)
      %Ecto.Changeset{data: %UserProfile{}}

  """
  def change_user_profile(%UserProfile{} = user_profile, attrs \\ %{}) do
    UserProfile.changeset(user_profile, attrs)
  end

  alias BinduBackend.Settings.SettingOverride

  @doc """
  Returns the list of setting_overrides.

  ## Examples

      iex> list_setting_overrides()
      [%SettingOverride{}, ...]

  """
  def list_setting_overrides do
    Repo.all(SettingOverride)
  end

  @doc """
  Gets a single setting_override.

  Raises `Ecto.NoResultsError` if the Setting override does not exist.

  ## Examples

      iex> get_setting_override!(123)
      %SettingOverride{}

      iex> get_setting_override!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting_override!(id), do: Repo.get!(SettingOverride, id)

  @doc """
  Creates a setting_override.

  ## Examples

      iex> create_setting_override(%{field: value})
      {:ok, %SettingOverride{}}

      iex> create_setting_override(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting_override(attrs) do
    %SettingOverride{}
    |> SettingOverride.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting_override.

  ## Examples

      iex> update_setting_override(setting_override, %{field: new_value})
      {:ok, %SettingOverride{}}

      iex> update_setting_override(setting_override, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting_override(%SettingOverride{} = setting_override, attrs) do
    setting_override
    |> SettingOverride.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting_override.

  ## Examples

      iex> delete_setting_override(setting_override)
      {:ok, %SettingOverride{}}

      iex> delete_setting_override(setting_override)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting_override(%SettingOverride{} = setting_override) do
    Repo.delete(setting_override)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting_override changes.

  ## Examples

      iex> change_setting_override(setting_override)
      %Ecto.Changeset{data: %SettingOverride{}}

  """
  def change_setting_override(%SettingOverride{} = setting_override, attrs \\ %{}) do
    SettingOverride.changeset(setting_override, attrs)
  end

  alias BinduBackend.Settings.ElevationToken

  @doc """
  Returns the list of elevation_tokens.

  ## Examples

      iex> list_elevation_tokens()
      [%ElevationToken{}, ...]

  """
  def list_elevation_tokens do
    Repo.all(ElevationToken)
  end

  @doc """
  Gets a single elevation_token.

  Raises `Ecto.NoResultsError` if the Elevation token does not exist.

  ## Examples

      iex> get_elevation_token!(123)
      %ElevationToken{}

      iex> get_elevation_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_elevation_token!(id), do: Repo.get!(ElevationToken, id)

  @doc """
  Creates a elevation_token.

  ## Examples

      iex> create_elevation_token(%{field: value})
      {:ok, %ElevationToken{}}

      iex> create_elevation_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_elevation_token(attrs) do
    %ElevationToken{}
    |> ElevationToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a elevation_token.

  ## Examples

      iex> update_elevation_token(elevation_token, %{field: new_value})
      {:ok, %ElevationToken{}}

      iex> update_elevation_token(elevation_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_elevation_token(%ElevationToken{} = elevation_token, attrs) do
    elevation_token
    |> ElevationToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a elevation_token.

  ## Examples

      iex> delete_elevation_token(elevation_token)
      {:ok, %ElevationToken{}}

      iex> delete_elevation_token(elevation_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_elevation_token(%ElevationToken{} = elevation_token) do
    Repo.delete(elevation_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking elevation_token changes.

  ## Examples

      iex> change_elevation_token(elevation_token)
      %Ecto.Changeset{data: %ElevationToken{}}

  """
  def change_elevation_token(%ElevationToken{} = elevation_token, attrs \\ %{}) do
    ElevationToken.changeset(elevation_token, attrs)
  end

  alias BinduBackend.Settings.SettingAuditLog

  @doc """
  Returns the list of setting_audit_logs.

  ## Examples

      iex> list_setting_audit_logs()
      [%SettingAuditLog{}, ...]

  """
  def list_setting_audit_logs do
    Repo.all(SettingAuditLog)
  end

  @doc """
  Gets a single setting_audit_log.

  Raises `Ecto.NoResultsError` if the Setting audit log does not exist.

  ## Examples

      iex> get_setting_audit_log!(123)
      %SettingAuditLog{}

      iex> get_setting_audit_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting_audit_log!(id), do: Repo.get!(SettingAuditLog, id)

  @doc """
  Creates a setting_audit_log.

  ## Examples

      iex> create_setting_audit_log(%{field: value})
      {:ok, %SettingAuditLog{}}

      iex> create_setting_audit_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting_audit_log(attrs) do
    %SettingAuditLog{}
    |> SettingAuditLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting_audit_log.

  ## Examples

      iex> update_setting_audit_log(setting_audit_log, %{field: new_value})
      {:ok, %SettingAuditLog{}}

      iex> update_setting_audit_log(setting_audit_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting_audit_log(%SettingAuditLog{} = setting_audit_log, attrs) do
    setting_audit_log
    |> SettingAuditLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting_audit_log.

  ## Examples

      iex> delete_setting_audit_log(setting_audit_log)
      {:ok, %SettingAuditLog{}}

      iex> delete_setting_audit_log(setting_audit_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting_audit_log(%SettingAuditLog{} = setting_audit_log) do
    Repo.delete(setting_audit_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting_audit_log changes.

  ## Examples

      iex> change_setting_audit_log(setting_audit_log)
      %Ecto.Changeset{data: %SettingAuditLog{}}

  """
  def change_setting_audit_log(%SettingAuditLog{} = setting_audit_log, attrs \\ %{}) do
    SettingAuditLog.changeset(setting_audit_log, attrs)
  end
end
