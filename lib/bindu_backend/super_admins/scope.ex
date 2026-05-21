defmodule BinduBackend.SuperAdmins.Scope do
  @moduledoc """
  Defines the scope of the caller to be used throughout the app.

  The `BinduBackend.SuperAdmins.Scope` allows public interfaces to receive
  information about the caller, such as if the call is initiated from an
  end-user, and if so, which user. Additionally, such a scope can carry fields
  such as "super user" or other privileges for use as authorization, or to
  ensure specific code paths can only be access for a given scope.

  It is useful for logging as well as for scoping pubsub subscriptions and
  broadcasts when a caller subscribes to an interface or performs a particular
  action.

  Feel free to extend the fields on this struct to fit the needs of
  growing application requirements.
  """

  alias BinduBackend.SuperAdmins.SuperAdmin

  defstruct super_admin: nil

  @doc """
  Creates a scope for the given super_admin.

  Returns nil if no super_admin is given.
  """
  def for_super_admin(%SuperAdmin{} = super_admin) do
    %__MODULE__{super_admin: super_admin}
  end

  def for_super_admin(nil), do: nil
end
