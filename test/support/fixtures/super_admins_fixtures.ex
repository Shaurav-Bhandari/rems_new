defmodule BinduBackend.SuperAdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BinduBackend.SuperAdmins` context.
  """

  import Ecto.Query

  alias BinduBackend.SuperAdmins
  alias BinduBackend.SuperAdmins.Scope

  def unique_super_admin_email, do: "super_admin#{System.unique_integer()}@example.com"
  def valid_super_admin_password, do: "hello world!"

  def valid_super_admin_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_super_admin_email()
    })
  end

  def unconfirmed_super_admin_fixture(attrs \\ %{}) do
    {:ok, super_admin} =
      attrs
      |> valid_super_admin_attributes()
      |> SuperAdmins.register_super_admin()

    super_admin
  end

  def super_admin_fixture(attrs \\ %{}) do
    super_admin = unconfirmed_super_admin_fixture(attrs)

    token =
      extract_super_admin_token(fn url ->
        SuperAdmins.deliver_login_instructions(super_admin, url)
      end)

    {:ok, {super_admin, _expired_tokens}} =
      SuperAdmins.login_super_admin_by_magic_link(token)

    super_admin
  end

  def super_admin_scope_fixture do
    super_admin = super_admin_fixture()
    super_admin_scope_fixture(super_admin)
  end

  def super_admin_scope_fixture(super_admin) do
    Scope.for_super_admin(super_admin)
  end

  def set_password(super_admin) do
    {:ok, {super_admin, _expired_tokens}} =
      SuperAdmins.update_super_admin_password(super_admin, %{
        password: valid_super_admin_password()
      })

    super_admin
  end

  def extract_super_admin_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  def override_token_authenticated_at(token, authenticated_at) when is_binary(token) do
    BinduBackend.Repo.update_all(
      from(t in SuperAdmins.SuperAdminToken,
        where: t.token == ^token
      ),
      set: [authenticated_at: authenticated_at]
    )
  end

  def generate_super_admin_magic_link_token(super_admin) do
    {encoded_token, super_admin_token} =
      SuperAdmins.SuperAdminToken.build_email_token(super_admin, "login")

    BinduBackend.Repo.insert!(super_admin_token)
    {encoded_token, super_admin_token.token}
  end

  def offset_super_admin_token(token, amount_to_add, unit) do
    dt = DateTime.add(DateTime.utc_now(:second), amount_to_add, unit)

    BinduBackend.Repo.update_all(
      from(ut in SuperAdmins.SuperAdminToken, where: ut.token == ^token),
      set: [inserted_at: dt, authenticated_at: dt]
    )
  end
end
