defmodule BinduBackendWeb.SuperAdminSessionControllerTest do
  use BinduBackendWeb.ConnCase, async: true

  import BinduBackend.SuperAdminsFixtures
  alias BinduBackend.SuperAdmins

  setup do
    %{
      unconfirmed_super_admin: unconfirmed_super_admin_fixture(),
      super_admin: super_admin_fixture()
    }
  end

  describe "POST /super_admins/log-in - email and password" do
    test "logs the super_admin in", %{conn: conn, super_admin: super_admin} do
      super_admin = set_password(super_admin)

      conn =
        post(conn, ~p"/super_admins/log-in", %{
          "super_admin" => %{
            "email" => super_admin.email,
            "password" => valid_super_admin_password()
          }
        })

      assert get_session(conn, :super_admin_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ super_admin.email
      assert response =~ ~p"/super_admins/settings"
      assert response =~ ~p"/super_admins/log-out"
    end

    test "logs the super_admin in with remember me", %{conn: conn, super_admin: super_admin} do
      super_admin = set_password(super_admin)

      conn =
        post(conn, ~p"/super_admins/log-in", %{
          "super_admin" => %{
            "email" => super_admin.email,
            "password" => valid_super_admin_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_bindu_backend_web_super_admin_remember_me"]
      assert redirected_to(conn) == ~p"/"
    end

    test "logs the super_admin in with return to", %{conn: conn, super_admin: super_admin} do
      super_admin = set_password(super_admin)

      conn =
        conn
        |> init_test_session(super_admin_return_to: "/foo/bar")
        |> post(~p"/super_admins/log-in", %{
          "super_admin" => %{
            "email" => super_admin.email,
            "password" => valid_super_admin_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "redirects to login page with invalid credentials", %{
      conn: conn,
      super_admin: super_admin
    } do
      conn =
        post(conn, ~p"/super_admins/log-in?mode=password", %{
          "super_admin" => %{"email" => super_admin.email, "password" => "invalid_password"}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"
      assert redirected_to(conn) == ~p"/super_admins/log-in"
    end
  end

  describe "POST /super_admins/log-in - magic link" do
    test "logs the super_admin in", %{conn: conn, super_admin: super_admin} do
      {token, _hashed_token} = generate_super_admin_magic_link_token(super_admin)

      conn =
        post(conn, ~p"/super_admins/log-in", %{
          "super_admin" => %{"token" => token}
        })

      assert get_session(conn, :super_admin_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ super_admin.email
      assert response =~ ~p"/super_admins/settings"
      assert response =~ ~p"/super_admins/log-out"
    end

    test "confirms unconfirmed super_admin", %{conn: conn, unconfirmed_super_admin: super_admin} do
      {token, _hashed_token} = generate_super_admin_magic_link_token(super_admin)
      refute super_admin.confirmed_at

      conn =
        post(conn, ~p"/super_admins/log-in", %{
          "super_admin" => %{"token" => token},
          "_action" => "confirmed"
        })

      assert get_session(conn, :super_admin_token)
      assert redirected_to(conn) == ~p"/"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Super admin confirmed successfully."

      assert SuperAdmins.get_super_admin!(super_admin.id).confirmed_at

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ super_admin.email
      assert response =~ ~p"/super_admins/settings"
      assert response =~ ~p"/super_admins/log-out"
    end

    test "redirects to login page when magic link is invalid", %{conn: conn} do
      conn =
        post(conn, ~p"/super_admins/log-in", %{
          "super_admin" => %{"token" => "invalid"}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "The link is invalid or it has expired."

      assert redirected_to(conn) == ~p"/super_admins/log-in"
    end
  end

  describe "DELETE /super_admins/log-out" do
    test "logs the super_admin out", %{conn: conn, super_admin: super_admin} do
      conn = conn |> log_in_super_admin(super_admin) |> delete(~p"/super_admins/log-out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :super_admin_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the super_admin is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/super_admins/log-out")
      assert redirected_to(conn) == ~p"/"
      refute get_session(conn, :super_admin_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end
  end
end
