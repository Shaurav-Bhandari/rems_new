defmodule BinduBackend.SuperAdminsTest do
  use BinduBackend.DataCase

  alias BinduBackend.SuperAdmins

  import BinduBackend.SuperAdminsFixtures
  alias BinduBackend.SuperAdmins.{SuperAdmin, SuperAdminToken}

  describe "get_super_admin_by_email/1" do
    test "does not return the super_admin if the email does not exist" do
      refute SuperAdmins.get_super_admin_by_email("unknown@example.com")
    end

    test "returns the super_admin if the email exists" do
      %{id: id} = super_admin = super_admin_fixture()
      assert %SuperAdmin{id: ^id} = SuperAdmins.get_super_admin_by_email(super_admin.email)
    end
  end

  describe "get_super_admin_by_email_and_password/2" do
    test "does not return the super_admin if the email does not exist" do
      refute SuperAdmins.get_super_admin_by_email_and_password(
               "unknown@example.com",
               "hello world!"
             )
    end

    test "does not return the super_admin if the password is not valid" do
      super_admin = super_admin_fixture() |> set_password()
      refute SuperAdmins.get_super_admin_by_email_and_password(super_admin.email, "invalid")
    end

    test "returns the super_admin if the email and password are valid" do
      %{id: id} = super_admin = super_admin_fixture() |> set_password()

      assert %SuperAdmin{id: ^id} =
               SuperAdmins.get_super_admin_by_email_and_password(
                 super_admin.email,
                 valid_super_admin_password()
               )
    end
  end

  describe "get_super_admin!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        SuperAdmins.get_super_admin!(-1)
      end
    end

    test "returns the super_admin with the given id" do
      %{id: id} = super_admin = super_admin_fixture()
      assert %SuperAdmin{id: ^id} = SuperAdmins.get_super_admin!(super_admin.id)
    end
  end

  describe "register_super_admin/1" do
    test "requires email to be set" do
      {:error, changeset} = SuperAdmins.register_super_admin(%{})

      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates email when given" do
      {:error, changeset} = SuperAdmins.register_super_admin(%{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum values for email for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = SuperAdmins.register_super_admin(%{email: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness" do
      %{email: email} = super_admin_fixture()
      {:error, changeset} = SuperAdmins.register_super_admin(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the uppercased email too, to check that email case is ignored.
      {:error, changeset} = SuperAdmins.register_super_admin(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers super_admins without password" do
      email = unique_super_admin_email()

      {:ok, super_admin} =
        SuperAdmins.register_super_admin(valid_super_admin_attributes(email: email))

      assert super_admin.email == email
      assert is_nil(super_admin.hashed_password)
      assert is_nil(super_admin.confirmed_at)
      assert is_nil(super_admin.password)
    end
  end

  describe "sudo_mode?/2" do
    test "validates the authenticated_at time" do
      now = DateTime.utc_now()

      assert SuperAdmins.sudo_mode?(%SuperAdmin{authenticated_at: DateTime.utc_now()})

      assert SuperAdmins.sudo_mode?(%SuperAdmin{
               authenticated_at: DateTime.add(now, -19, :minute)
             })

      refute SuperAdmins.sudo_mode?(%SuperAdmin{
               authenticated_at: DateTime.add(now, -21, :minute)
             })

      # minute override
      refute SuperAdmins.sudo_mode?(
               %SuperAdmin{authenticated_at: DateTime.add(now, -11, :minute)},
               -10
             )

      # not authenticated
      refute SuperAdmins.sudo_mode?(%SuperAdmin{})
    end
  end

  describe "change_super_admin_email/3" do
    test "returns a super_admin changeset" do
      assert %Ecto.Changeset{} = changeset = SuperAdmins.change_super_admin_email(%SuperAdmin{})
      assert changeset.required == [:email]
    end
  end

  describe "deliver_super_admin_update_email_instructions/3" do
    setup do
      %{super_admin: super_admin_fixture()}
    end

    test "sends token through notification", %{super_admin: super_admin} do
      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_super_admin_update_email_instructions(
            super_admin,
            "current@example.com",
            url
          )
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert super_admin_token = Repo.get_by(SuperAdminToken, token: :crypto.hash(:sha256, token))
      assert super_admin_token.super_admin_id == super_admin.id
      assert super_admin_token.sent_to == super_admin.email
      assert super_admin_token.context == "change:current@example.com"
    end
  end

  describe "update_super_admin_email/2" do
    setup do
      super_admin = unconfirmed_super_admin_fixture()
      email = unique_super_admin_email()

      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_super_admin_update_email_instructions(
            %{super_admin | email: email},
            super_admin.email,
            url
          )
        end)

      %{super_admin: super_admin, token: token, email: email}
    end

    test "updates the email with a valid token", %{
      super_admin: super_admin,
      token: token,
      email: email
    } do
      assert {:ok, %{email: ^email}} = SuperAdmins.update_super_admin_email(super_admin, token)
      changed_super_admin = Repo.get!(SuperAdmin, super_admin.id)
      assert changed_super_admin.email != super_admin.email
      assert changed_super_admin.email == email
      refute Repo.get_by(SuperAdminToken, super_admin_id: super_admin.id)
    end

    test "does not update email with invalid token", %{super_admin: super_admin} do
      assert SuperAdmins.update_super_admin_email(super_admin, "oops") ==
               {:error, :transaction_aborted}

      assert Repo.get!(SuperAdmin, super_admin.id).email == super_admin.email
      assert Repo.get_by(SuperAdminToken, super_admin_id: super_admin.id)
    end

    test "does not update email if super_admin email changed", %{
      super_admin: super_admin,
      token: token
    } do
      assert SuperAdmins.update_super_admin_email(
               %{super_admin | email: "current@example.com"},
               token
             ) ==
               {:error, :transaction_aborted}

      assert Repo.get!(SuperAdmin, super_admin.id).email == super_admin.email
      assert Repo.get_by(SuperAdminToken, super_admin_id: super_admin.id)
    end

    test "does not update email if token expired", %{super_admin: super_admin, token: token} do
      {1, nil} = Repo.update_all(SuperAdminToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])

      assert SuperAdmins.update_super_admin_email(super_admin, token) ==
               {:error, :transaction_aborted}

      assert Repo.get!(SuperAdmin, super_admin.id).email == super_admin.email
      assert Repo.get_by(SuperAdminToken, super_admin_id: super_admin.id)
    end
  end

  describe "change_super_admin_password/3" do
    test "returns a super_admin changeset" do
      assert %Ecto.Changeset{} =
               changeset = SuperAdmins.change_super_admin_password(%SuperAdmin{})

      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        SuperAdmins.change_super_admin_password(
          %SuperAdmin{},
          %{
            "password" => "new valid password"
          },
          hash_password: false
        )

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_super_admin_password/2" do
    setup do
      %{super_admin: super_admin_fixture()}
    end

    test "validates password", %{super_admin: super_admin} do
      {:error, changeset} =
        SuperAdmins.update_super_admin_password(super_admin, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{super_admin: super_admin} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        SuperAdmins.update_super_admin_password(super_admin, %{password: too_long})

      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{super_admin: super_admin} do
      {:ok, {super_admin, expired_tokens}} =
        SuperAdmins.update_super_admin_password(super_admin, %{
          password: "new valid password"
        })

      assert expired_tokens == []
      assert is_nil(super_admin.password)

      assert SuperAdmins.get_super_admin_by_email_and_password(
               super_admin.email,
               "new valid password"
             )
    end

    test "deletes all tokens for the given super_admin", %{super_admin: super_admin} do
      _ = SuperAdmins.generate_super_admin_session_token(super_admin)

      {:ok, {_, _}} =
        SuperAdmins.update_super_admin_password(super_admin, %{
          password: "new valid password"
        })

      refute Repo.get_by(SuperAdminToken, super_admin_id: super_admin.id)
    end
  end

  describe "generate_super_admin_session_token/1" do
    setup do
      %{super_admin: super_admin_fixture()}
    end

    test "generates a token", %{super_admin: super_admin} do
      token = SuperAdmins.generate_super_admin_session_token(super_admin)
      assert super_admin_token = Repo.get_by(SuperAdminToken, token: token)
      assert super_admin_token.context == "session"
      assert super_admin_token.authenticated_at != nil

      # Creating the same token for another super_admin should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%SuperAdminToken{
          token: super_admin_token.token,
          super_admin_id: super_admin_fixture().id,
          context: "session"
        })
      end
    end

    test "duplicates the authenticated_at of given super_admin in new token", %{
      super_admin: super_admin
    } do
      super_admin = %{
        super_admin
        | authenticated_at: DateTime.add(DateTime.utc_now(:second), -3600)
      }

      token = SuperAdmins.generate_super_admin_session_token(super_admin)
      assert super_admin_token = Repo.get_by(SuperAdminToken, token: token)
      assert super_admin_token.authenticated_at == super_admin.authenticated_at
      assert DateTime.compare(super_admin_token.inserted_at, super_admin.authenticated_at) == :gt
    end
  end

  describe "get_super_admin_by_session_token/1" do
    setup do
      super_admin = super_admin_fixture()
      token = SuperAdmins.generate_super_admin_session_token(super_admin)
      %{super_admin: super_admin, token: token}
    end

    test "returns super_admin by token", %{super_admin: super_admin, token: token} do
      assert {session_super_admin, token_inserted_at} =
               SuperAdmins.get_super_admin_by_session_token(token)

      assert session_super_admin.id == super_admin.id
      assert session_super_admin.authenticated_at != nil
      assert token_inserted_at != nil
    end

    test "does not return super_admin for invalid token" do
      refute SuperAdmins.get_super_admin_by_session_token("oops")
    end

    test "does not return super_admin for expired token", %{token: token} do
      dt = ~N[2020-01-01 00:00:00]
      {1, nil} = Repo.update_all(SuperAdminToken, set: [inserted_at: dt, authenticated_at: dt])
      refute SuperAdmins.get_super_admin_by_session_token(token)
    end
  end

  describe "get_super_admin_by_magic_link_token/1" do
    setup do
      super_admin = super_admin_fixture()
      {encoded_token, _hashed_token} = generate_super_admin_magic_link_token(super_admin)
      %{super_admin: super_admin, token: encoded_token}
    end

    test "returns super_admin by token", %{super_admin: super_admin, token: token} do
      assert session_super_admin = SuperAdmins.get_super_admin_by_magic_link_token(token)
      assert session_super_admin.id == super_admin.id
    end

    test "does not return super_admin for invalid token" do
      refute SuperAdmins.get_super_admin_by_magic_link_token("oops")
    end

    test "does not return super_admin for expired token", %{token: token} do
      {1, nil} = Repo.update_all(SuperAdminToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute SuperAdmins.get_super_admin_by_magic_link_token(token)
    end
  end

  describe "login_super_admin_by_magic_link/1" do
    test "confirms super_admin and expires tokens" do
      super_admin = unconfirmed_super_admin_fixture()
      refute super_admin.confirmed_at
      {encoded_token, hashed_token} = generate_super_admin_magic_link_token(super_admin)

      assert {:ok, {super_admin, [%{token: ^hashed_token}]}} =
               SuperAdmins.login_super_admin_by_magic_link(encoded_token)

      assert super_admin.confirmed_at
    end

    test "returns super_admin and (deleted) token for confirmed super_admin" do
      super_admin = super_admin_fixture()
      assert super_admin.confirmed_at
      {encoded_token, _hashed_token} = generate_super_admin_magic_link_token(super_admin)

      assert {:ok, {^super_admin, []}} =
               SuperAdmins.login_super_admin_by_magic_link(encoded_token)

      # one time use only
      assert {:error, :not_found} = SuperAdmins.login_super_admin_by_magic_link(encoded_token)
    end

    test "raises when unconfirmed super_admin has password set" do
      super_admin = unconfirmed_super_admin_fixture()
      {1, nil} = Repo.update_all(SuperAdmin, set: [hashed_password: "hashed"])
      {encoded_token, _hashed_token} = generate_super_admin_magic_link_token(super_admin)

      assert_raise RuntimeError, ~r/magic link log in is not allowed/, fn ->
        SuperAdmins.login_super_admin_by_magic_link(encoded_token)
      end
    end
  end

  describe "delete_super_admin_session_token/1" do
    test "deletes the token" do
      super_admin = super_admin_fixture()
      token = SuperAdmins.generate_super_admin_session_token(super_admin)
      assert SuperAdmins.delete_super_admin_session_token(token) == :ok
      refute SuperAdmins.get_super_admin_by_session_token(token)
    end
  end

  describe "deliver_login_instructions/2" do
    setup do
      %{super_admin: unconfirmed_super_admin_fixture()}
    end

    test "sends token through notification", %{super_admin: super_admin} do
      token =
        extract_super_admin_token(fn url ->
          SuperAdmins.deliver_login_instructions(super_admin, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert super_admin_token = Repo.get_by(SuperAdminToken, token: :crypto.hash(:sha256, token))
      assert super_admin_token.super_admin_id == super_admin.id
      assert super_admin_token.sent_to == super_admin.email
      assert super_admin_token.context == "login"
    end
  end

  describe "inspect/2 for the SuperAdmin module" do
    test "does not include password" do
      refute inspect(%SuperAdmin{password: "123456"}) =~ "password: \"123456\""
    end
  end
end
