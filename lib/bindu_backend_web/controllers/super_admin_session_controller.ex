defmodule BinduBackendWeb.SuperAdminSessionController do
  use BinduBackendWeb, :controller

  alias BinduBackend.SuperAdmins
  alias BinduBackendWeb.SuperAdminAuth

  def create(conn, %{"_action" => "confirmed"} = params) do
    create(conn, params, "Super admin confirmed successfully.")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  # magic link login
  defp create(conn, %{"super_admin" => %{"token" => token} = super_admin_params}, info) do
    case SuperAdmins.login_super_admin_by_magic_link(token) do
      {:ok, {super_admin, tokens_to_disconnect}} ->
        SuperAdminAuth.disconnect_sessions(tokens_to_disconnect)

        conn
        |> put_flash(:info, info)
        |> SuperAdminAuth.log_in_super_admin(super_admin, super_admin_params)

      _ ->
        conn
        |> put_flash(:error, "The link is invalid or it has expired.")
        |> redirect(to: ~p"/super_admins/log-in")
    end
  end

  # email + password login
  defp create(conn, %{"super_admin" => super_admin_params}, info) do
    %{"email" => email, "password" => password} = super_admin_params

    if super_admin = SuperAdmins.get_super_admin_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> SuperAdminAuth.log_in_super_admin(super_admin, super_admin_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/super_admins/log-in")
    end
  end

  def update_password(conn, %{"super_admin" => super_admin_params} = params) do
    super_admin = conn.assigns.current_scope.super_admin
    true = SuperAdmins.sudo_mode?(super_admin)

    {:ok, {_super_admin, expired_tokens}} =
      SuperAdmins.update_super_admin_password(super_admin, super_admin_params)

    # disconnect all existing LiveViews with old sessions
    SuperAdminAuth.disconnect_sessions(expired_tokens)

    conn
    |> put_session(:super_admin_return_to, ~p"/super_admins/settings")
    |> create(params, "Password updated successfully!")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> SuperAdminAuth.log_out_super_admin()
  end
end
