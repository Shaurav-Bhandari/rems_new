defmodule BinduBackendWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use BinduBackendWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint BinduBackendWeb.Endpoint

      use BinduBackendWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import BinduBackendWeb.ConnCase
    end
  end

  setup tags do
    BinduBackend.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn} = context) do
    user = BinduBackend.AccountsFixtures.user_fixture()
    scope = BinduBackend.Accounts.Scope.for_user(user)

    opts =
      context
      |> Map.take([:token_authenticated_at])
      |> Enum.into([])

    %{conn: log_in_user(conn, user, opts), user: user, scope: scope}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user, opts \\ []) do
    token = BinduBackend.Accounts.generate_user_session_token(user)

    maybe_set_user_token_authenticated_at(token, opts[:token_authenticated_at])

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end

  defp maybe_set_user_token_authenticated_at(_token, nil), do: nil

  defp maybe_set_user_token_authenticated_at(token, authenticated_at) do
    BinduBackend.AccountsFixtures.override_token_authenticated_at(token, authenticated_at)
  end

  @doc """
  Setup helper that registers and logs in super_admins.

      setup :register_and_log_in_super_admin

  It stores an updated connection and a registered super_admin in the
  test context.
  """
  def register_and_log_in_super_admin(%{conn: conn} = context) do
    super_admin = BinduBackend.SuperAdminsFixtures.super_admin_fixture()
    scope = BinduBackend.SuperAdmins.Scope.for_super_admin(super_admin)

    opts =
      context
      |> Map.take([:token_authenticated_at])
      |> Enum.into([])

    %{conn: log_in_super_admin(conn, super_admin, opts), super_admin: super_admin, scope: scope}
  end

  @doc """
  Logs the given `super_admin` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_super_admin(conn, super_admin, opts \\ []) do
    token = BinduBackend.SuperAdmins.generate_super_admin_session_token(super_admin)

    maybe_set_super_admin_token_authenticated_at(token, opts[:token_authenticated_at])

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:super_admin_token, token)
  end

  defp maybe_set_super_admin_token_authenticated_at(_token, nil), do: nil

  defp maybe_set_super_admin_token_authenticated_at(token, authenticated_at) do
    BinduBackend.SuperAdminsFixtures.override_token_authenticated_at(token, authenticated_at)
  end
end
