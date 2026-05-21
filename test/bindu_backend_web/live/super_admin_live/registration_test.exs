defmodule BinduBackendWeb.SuperAdminLive.RegistrationTest do
  use BinduBackendWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import BinduBackend.SuperAdminsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/super_admins/register")

      assert html =~ "Register"
      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> log_in_super_admin(super_admin_fixture())
        |> live(~p"/super_admins/register")
        |> follow_redirect(conn, ~p"/")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(super_admin: %{"email" => "with spaces"})

      assert result =~ "Register"
      assert result =~ "must have the @ sign and no spaces"
    end
  end

  describe "register super_admin" do
    test "creates account but does not log in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/register")

      email = unique_super_admin_email()

      form =
        form(lv, "#registration_form", super_admin: valid_super_admin_attributes(email: email))

      {:ok, _lv, html} =
        render_submit(form)
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert html =~
               ~r/An email was sent to .*, please access it to confirm your account/
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/register")

      super_admin = super_admin_fixture(%{email: "test@email.com"})

      result =
        lv
        |> form("#registration_form",
          super_admin: %{"email" => super_admin.email}
        )
        |> render_submit()

      assert result =~ "has already been taken"
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the Log in button is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/super_admins/register")

      {:ok, _login_live, login_html} =
        lv
        |> element("main a", "Log in")
        |> render_click()
        |> follow_redirect(conn, ~p"/super_admins/log-in")

      assert login_html =~ "Log in"
    end
  end
end
