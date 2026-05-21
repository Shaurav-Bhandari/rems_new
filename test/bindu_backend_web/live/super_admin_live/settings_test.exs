defmodule BinduBackendWeb.SuperAdminLive.SettingsTest do
  use BinduBackendWeb.ConnCase, async: true

  alias BinduBackend.SuperAdmins
  import Phoenix.LiveViewTest
  import BinduBackend.SuperAdminsFixtures

  describe "Settings page" do
    test "renders settings page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_super_admin(super_admin_fixture())
        |> live(~p"/super_admins/settings")

      assert html =~ "Change Email"
      assert html =~ "Save Password"
    end

    test "redirects if super_admin is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/super_admins/settings")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/super_admins/log-in"
      assert %{"error" => "You must log in to access this page."} = flash
    end

    test "redirects if super_admin is not in sudo mode", %{conn: conn} do
      {:ok, conn} =
        conn
        |> log_in_super_admin(super_admin_fixture(),
          token_authenticated_at: DateTime.add(DateTime.utc_now(:second), -11, :minute)
        )
        |> live(~p"/super_admins/settings")
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert conn.resp_body =~ "You must re-authenticate to access this page."
    end
  end

  describe "update email form" do
    setup %{conn: conn} do
      super_admin = super_admin_fixture()
      %{conn: log_in_super_admin(conn, super_admin), super_admin: super_admin}
    end

    test "updates the super_admin email", %{conn: conn, super_admin: super_admin} do
      new_email = unique_super_admin_email()

      {:ok, lv, _html} = live(conn, ~p"/super_admins/settings")

      result =
        lv
        |> form("#email_form", %{
          "super_admin" => %{"email" => new_email}
        })
        |> render_submit()

      assert result =~ "A link to confirm your email"
      assert SuperAdmins.get_super_admin_by_email(super_admin.email)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/settings")

      result =
        lv
        |> element("#email_form")
        |> render_change(%{
          "action" => "update_email",
          "super_admin" => %{"email" => "with spaces"}
        })

      assert result =~ "Change Email"
      assert result =~ "must have the @ sign and no spaces"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn, super_admin: super_admin} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/settings")

      result =
        lv
        |> form("#email_form", %{
          "super_admin" => %{"email" => super_admin.email}
        })
        |> render_submit()

      assert result =~ "Change Email"
      assert result =~ "did not change"
    end
  end

  describe "update password form" do
    setup %{conn: conn} do
      super_admin = super_admin_fixture()
      %{conn: log_in_super_admin(conn, super_admin), super_admin: super_admin}
    end

    test "updates the super_admin password", %{conn: conn, super_admin: super_admin} do
      new_password = valid_super_admin_password()

      {:ok, lv, _html} = live(conn, ~p"/super_admins/settings")

      form =
        form(lv, "#password_form", %{
          "super_admin" => %{
            "email" => super_admin.email,
            "password" => new_password,
            "password_confirmation" => new_password
          }
        })

      render_submit(form)

      new_password_conn = follow_trigger_action(form, conn)

      assert redirected_to(new_password_conn) == ~p"/super_admins/settings"

      assert get_session(new_password_conn, :super_admin_token) !=
               get_session(conn, :super_admin_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               "Password updated successfully"

      assert SuperAdmins.get_super_admin_by_email_and_password(super_admin.email, new_password)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/settings")

      result =
        lv
        |> element("#password_form")
        |> render_change(%{
          "super_admin" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      assert result =~ "Save Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/settings")

      result =
        lv
        |> form("#password_form", %{
          "super_admin" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      assert result =~ "Save Password"
      assert result =~ "should be at least 12 character(s)"
      assert result =~ "does not match password"
    end
  end

  describe "confirm email" do
    setup %{conn: conn} do
      super_admin = super_admin_fixture()
      email = unique_super_admin_email()

      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_super_admin_update_email_instructions(
            %{super_admin | email: email},
            super_admin.email,
            url
          )
        end)

      %{
        conn: log_in_super_admin(conn, super_admin),
        token: token,
        email: email,
        super_admin: super_admin
      }
    end

    test "updates the super_admin email once", %{
      conn: conn,
      super_admin: super_admin,
      token: token,
      email: email
    } do
      {:error, redirect} = live(conn, ~p"/super_admins/settings/confirm-email/#{token}")

      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/super_admins/settings"
      assert %{"info" => message} = flash
      assert message == "Email changed successfully."
      refute SuperAdmins.get_super_admin_by_email(super_admin.email)
      assert SuperAdmins.get_super_admin_by_email(email)

      # use confirm token again
      {:error, redirect} = live(conn, ~p"/super_admins/settings/confirm-email/#{token}")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/super_admins/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
    end

    test "does not update email with invalid token", %{conn: conn, super_admin: super_admin} do
      {:error, redirect} = live(conn, ~p"/super_admins/settings/confirm-email/oops")
      assert {:live_redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/super_admins/settings"
      assert %{"error" => message} = flash
      assert message == "Email change link is invalid or it has expired."
      assert SuperAdmins.get_super_admin_by_email(super_admin.email)
    end

    test "redirects if super_admin is not logged in", %{token: token} do
      conn = build_conn()
      {:error, redirect} = live(conn, ~p"/super_admins/settings/confirm-email/#{token}")
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/super_admins/log-in"
      assert %{"error" => message} = flash
      assert message == "You must log in to access this page."
    end
  end
end
