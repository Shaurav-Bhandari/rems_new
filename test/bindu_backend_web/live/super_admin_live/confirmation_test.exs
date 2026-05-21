defmodule BinduBackendWeb.SuperAdminLive.ConfirmationTest do
  use BinduBackendWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import BinduBackend.SuperAdminsFixtures

  alias BinduBackend.SuperAdmins

  setup do
    %{
      unconfirmed_super_admin: unconfirmed_super_admin_fixture(),
      confirmed_super_admin: super_admin_fixture()
    }
  end

  describe "Confirm super_admin" do
    test "renders confirmation page for unconfirmed super_admin", %{
      conn: conn,
      unconfirmed_super_admin: super_admin
    } do
      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_login_instructions(super_admin, url)
        end)

      {:ok, _lv, html} = live(conn, ~p"/super_admins/log-in/#{token}")
      assert html =~ "Confirm and stay logged in"
    end

    test "renders login page for confirmed super_admin", %{
      conn: conn,
      confirmed_super_admin: super_admin
    } do
      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_login_instructions(super_admin, url)
        end)

      {:ok, _lv, html} = live(conn, ~p"/super_admins/log-in/#{token}")
      refute html =~ "Confirm my account"
      assert html =~ "Keep me logged in on this device"
    end

    test "renders login page for already logged in super_admin", %{
      conn: conn,
      confirmed_super_admin: super_admin
    } do
      conn = log_in_super_admin(conn, super_admin)

      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_login_instructions(super_admin, url)
        end)

      {:ok, _lv, html} = live(conn, ~p"/super_admins/log-in/#{token}")
      refute html =~ "Confirm my account"
      assert html =~ "Log in"
    end

    test "confirms the given token once", %{conn: conn, unconfirmed_super_admin: super_admin} do
      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_login_instructions(super_admin, url)
        end)

      {:ok, lv, _html} = live(conn, ~p"/super_admins/log-in/#{token}")

      form = form(lv, "#confirmation_form", %{"super_admin" => %{"token" => token}})
      render_submit(form)

      conn = follow_trigger_action(form, conn)

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "SuperAdmin confirmed successfully"

      assert SuperAdmins.get_super_admin!(super_admin.id).confirmed_at
      # we are logged in now
      assert get_session(conn, :super_admin_token)
      assert redirected_to(conn) == ~p"/"

      # log out, new conn
      conn = build_conn()

      {:ok, _lv, html} =
        live(conn, ~p"/super_admins/log-in/#{token}")
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert html =~ "Magic link is invalid or it has expired"
    end

    test "logs confirmed super_admin in without changing confirmed_at", %{
      conn: conn,
      confirmed_super_admin: super_admin
    } do
      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_login_instructions(super_admin, url)
        end)

      {:ok, lv, _html} = live(conn, ~p"/super_admins/log-in/#{token}")

      form = form(lv, "#login_form", %{"super_admin" => %{"token" => token}})
      render_submit(form)

      conn = follow_trigger_action(form, conn)

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "Welcome back!"

      assert SuperAdmins.get_super_admin!(super_admin.id).confirmed_at == super_admin.confirmed_at

      # log out, new conn
      conn = build_conn()

      {:ok, _lv, html} =
        live(conn, ~p"/super_admins/log-in/#{token}")
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert html =~ "Magic link is invalid or it has expired"
    end

    test "raises error for invalid token", %{conn: conn} do
      {:ok, _lv, html} =
        live(conn, ~p"/super_admins/log-in/invalid-token")
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert html =~ "Magic link is invalid or it has expired"
    end
  end
end
