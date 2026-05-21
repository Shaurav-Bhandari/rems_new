defmodule BinduBackendWeb.SuperAdminLive.LoginTest do
  use BinduBackendWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import BinduBackend.SuperAdminsFixtures

  describe "login page" do
    test "renders login page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/super_admins/log-in")

      assert html =~ "Log in"
      assert html =~ "Register"
      assert html =~ "Log in with email"
    end
  end

  describe "super_admin login - magic link" do
    test "sends magic link email when super_admin exists", %{conn: conn} do
      super_admin = super_admin_fixture()

      {:ok, lv, _html} = live(conn, ~p"/super_admins/log-in")

      {:ok, _lv, html} =
        form(lv, "#login_form_magic", super_admin: %{email: super_admin.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert html =~ "If your email is in our system"

      assert BinduBackend.Repo.get_by!(BinduBackend.SuperAdmins.SuperAdminToken,
               super_admin_id: super_admin.id
             ).context ==
               "login"
    end

    test "does not disclose if super_admin is registered", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/log-in")

      {:ok, _lv, html} =
        form(lv, "#login_form_magic", super_admin: %{email: "idonotexist@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert html =~ "If your email is in our system"
    end
  end

  describe "super_admin login - password" do
    test "redirects if super_admin logs in with valid credentials", %{conn: conn} do
      super_admin = super_admin_fixture() |> set_password()

      {:ok, lv, _html} = live(conn, ~p"/super_admins/log-in")

      form =
        form(lv, "#login_form_password",
          super_admin: %{
            email: super_admin.email,
            password: valid_super_admin_password(),
            remember_me: true
          }
        )

      conn = submit_form(form, conn)

      assert redirected_to(conn) == ~p"/"
    end

    test "redirects to login page with a flash error if credentials are invalid", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/log-in")

      form =
        form(lv, "#login_form_password",
          super_admin: %{email: "test@email.com", password: "123456"}
        )

      render_submit(form, %{user: %{remember_me: true}})

      conn = follow_trigger_action(form, conn)
      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"
      assert redirected_to(conn) == ~p"/super_admins/log-in"
    end
  end

  describe "login navigation" do
    test "redirects to registration page when the Register button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/log-in")

      {:ok, _login_live, login_html} =
        lv
        |> element("main a", "Sign up")
        |> render_click()
        |> follow_redirect(conn, ~p"/super_admins/register")

      assert login_html =~ "Register"
    end
  end

  describe "re-authentication (sudo mode)" do
    setup %{conn: conn} do
      super_admin = super_admin_fixture()
      %{super_admin: super_admin, conn: log_in_super_admin(conn, super_admin)}
    end

    test "shows login page with email filled in", %{conn: conn, super_admin: super_admin} do
      {:ok, _lv, html} = live(conn, ~p"/super_admins/log-in")

      assert html =~ "You need to reauthenticate"
      refute html =~ "Register"
      assert html =~ "Log in with email"

      assert html =~
               ~s(<input type="email" name="super_admin[email]" id="login_form_magic_email" value="#{super_admin.email}")
    end
  end
end
