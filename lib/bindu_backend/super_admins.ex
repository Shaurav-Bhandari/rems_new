defmodule BinduBackend.SuperAdmins do
  @moduledoc """
  The SuperAdmins context.
  """

  import Ecto.Query, warn: false
  alias BinduBackend.Repo

  alias BinduBackend.SuperAdmins.{SuperAdmin, SuperAdminToken, SuperAdminNotifier}

  ## Database getters

  @doc """
  Gets a super_admin by email.

  ## Examples

      iex> get_super_admin_by_email("foo@example.com")
      %SuperAdmin{}

      iex> get_super_admin_by_email("unknown@example.com")
      nil

  """
  def get_super_admin_by_email(email) when is_binary(email) do
    Repo.get_by(SuperAdmin, email: email)
  end

  @doc """
  Gets a super_admin by email and password.

  ## Examples

      iex> get_super_admin_by_email_and_password("foo@example.com", "correct_password")
      %SuperAdmin{}

      iex> get_super_admin_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_super_admin_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    super_admin = Repo.get_by(SuperAdmin, email: email)
    if SuperAdmin.valid_password?(super_admin, password), do: super_admin
  end

  @doc """
  Gets a single super_admin.

  Raises `Ecto.NoResultsError` if the SuperAdmin does not exist.

  ## Examples

      iex> get_super_admin!(123)
      %SuperAdmin{}

      iex> get_super_admin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_super_admin!(id), do: Repo.get!(SuperAdmin, id)

  ## Super admin registration

  @doc """
  Registers a super_admin.

  ## Examples

      iex> register_super_admin(%{field: value})
      {:ok, %SuperAdmin{}}

      iex> register_super_admin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_super_admin(attrs) do
    %SuperAdmin{}
    |> SuperAdmin.email_changeset(attrs)
    |> Repo.insert()
  end

  ## Settings

  @doc """
  Checks whether the super_admin is in sudo mode.

  The super_admin is in sudo mode when the last authentication was done no further
  than 20 minutes ago. The limit can be given as second argument in minutes.
  """
  def sudo_mode?(super_admin, minutes \\ -20)

  def sudo_mode?(%SuperAdmin{authenticated_at: ts}, minutes) when is_struct(ts, DateTime) do
    DateTime.after?(ts, DateTime.utc_now() |> DateTime.add(minutes, :minute))
  end

  def sudo_mode?(_super_admin, _minutes), do: false

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the super_admin email.

  See `BinduBackend.SuperAdmins.SuperAdmin.email_changeset/3` for a list of supported options.

  ## Examples

      iex> change_super_admin_email(super_admin)
      %Ecto.Changeset{data: %SuperAdmin{}}

  """
  def change_super_admin_email(super_admin, attrs \\ %{}, opts \\ []) do
    SuperAdmin.email_changeset(super_admin, attrs, opts)
  end

  @doc """
  Updates the super_admin email using the given token.

  If the token matches, the super_admin email is updated and the token is deleted.
  """
  def update_super_admin_email(super_admin, token) do
    context = "change:#{super_admin.email}"

    Repo.transact(fn ->
      with {:ok, query} <- SuperAdminToken.verify_change_email_token_query(token, context),
           %SuperAdminToken{sent_to: email} <- Repo.one(query),
           {:ok, super_admin} <-
             Repo.update(SuperAdmin.email_changeset(super_admin, %{email: email})),
           {_count, _result} <-
             Repo.delete_all(
               from(SuperAdminToken, where: [super_admin_id: ^super_admin.id, context: ^context])
             ) do
        {:ok, super_admin}
      else
        _ -> {:error, :transaction_aborted}
      end
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the super_admin password.

  See `BinduBackend.SuperAdmins.SuperAdmin.password_changeset/3` for a list of supported options.

  ## Examples

      iex> change_super_admin_password(super_admin)
      %Ecto.Changeset{data: %SuperAdmin{}}

  """
  def change_super_admin_password(super_admin, attrs \\ %{}, opts \\ []) do
    SuperAdmin.password_changeset(super_admin, attrs, opts)
  end

  @doc """
  Updates the super_admin password.

  Returns a tuple with the updated super_admin, as well as a list of expired tokens.

  ## Examples

      iex> update_super_admin_password(super_admin, %{password: ...})
      {:ok, {%SuperAdmin{}, [...]}}

      iex> update_super_admin_password(super_admin, %{password: "too short"})
      {:error, %Ecto.Changeset{}}

  """
  def update_super_admin_password(super_admin, attrs) do
    super_admin
    |> SuperAdmin.password_changeset(attrs)
    |> update_super_admin_and_delete_all_tokens()
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_super_admin_session_token(super_admin) do
    {token, super_admin_token} = SuperAdminToken.build_session_token(super_admin)
    Repo.insert!(super_admin_token)
    token
  end

  @doc """
  Gets the super_admin with the given signed token.

  If the token is valid `{super_admin, token_inserted_at}` is returned, otherwise `nil` is returned.
  """
  def get_super_admin_by_session_token(token) do
    {:ok, query} = SuperAdminToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Gets the super_admin with the given magic link token.
  """
  def get_super_admin_by_magic_link_token(token) do
    with {:ok, query} <- SuperAdminToken.verify_magic_link_token_query(token),
         {super_admin, _token} <- Repo.one(query) do
      super_admin
    else
      _ -> nil
    end
  end

  @doc """
  Logs the super_admin in by magic link.

  There are three cases to consider:

  1. The super_admin has already confirmed their email. They are logged in
     and the magic link is expired.

  2. The super_admin has not confirmed their email and no password is set.
     In this case, the super_admin gets confirmed, logged in, and all tokens -
     including session ones - are expired. In theory, no other tokens
     exist but we delete all of them for best security practices.

  3. The super_admin has not confirmed their email but a password is set.
     This cannot happen in the default implementation but may be the
     source of security pitfalls. See the "Mixing magic link and password registration" section of
     `mix help phx.gen.auth`.
  """
  def login_super_admin_by_magic_link(token) do
    {:ok, query} = SuperAdminToken.verify_magic_link_token_query(token)

    case Repo.one(query) do
      # Prevent session fixation attacks by disallowing magic links for unconfirmed users with password
      {%SuperAdmin{confirmed_at: nil, hashed_password: hash}, _token} when not is_nil(hash) ->
        raise """
        magic link log in is not allowed for unconfirmed users with a password set!

        This cannot happen with the default implementation, which indicates that you
        might have adapted the code to a different use case. Please make sure to read the
        "Mixing magic link and password registration" section of `mix help phx.gen.auth`.
        """

      {%SuperAdmin{confirmed_at: nil} = super_admin, _token} ->
        super_admin
        |> SuperAdmin.confirm_changeset()
        |> update_super_admin_and_delete_all_tokens()

      {super_admin, token} ->
        Repo.delete!(token)
        {:ok, {super_admin, []}}

      nil ->
        {:error, :not_found}
    end
  end

  @doc ~S"""
  Delivers the update email instructions to the given super_admin.

  ## Examples

      iex> deliver_super_admin_update_email_instructions(super_admin, current_email, &url(~p"/super_admins/settings/confirm-email/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_super_admin_update_email_instructions(
        %SuperAdmin{} = super_admin,
        current_email,
        update_email_url_fun
      )
      when is_function(update_email_url_fun, 1) do
    {encoded_token, super_admin_token} =
      SuperAdminToken.build_email_token(super_admin, "change:#{current_email}")

    Repo.insert!(super_admin_token)

    SuperAdminNotifier.deliver_update_email_instructions(
      super_admin,
      update_email_url_fun.(encoded_token)
    )
  end

  @doc """
  Delivers the magic link login instructions to the given super_admin.
  """
  def deliver_login_instructions(%SuperAdmin{} = super_admin, magic_link_url_fun)
      when is_function(magic_link_url_fun, 1) do
    {encoded_token, super_admin_token} = SuperAdminToken.build_email_token(super_admin, "login")
    Repo.insert!(super_admin_token)
    SuperAdminNotifier.deliver_login_instructions(super_admin, magic_link_url_fun.(encoded_token))
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_super_admin_session_token(token) do
    Repo.delete_all(from(SuperAdminToken, where: [token: ^token, context: "session"]))
    :ok
  end

  ## Token helper

  defp update_super_admin_and_delete_all_tokens(changeset) do
    Repo.transact(fn ->
      with {:ok, super_admin} <- Repo.update(changeset) do
        tokens_to_expire = Repo.all_by(SuperAdminToken, super_admin_id: super_admin.id)

        Repo.delete_all(
          from(t in SuperAdminToken, where: t.id in ^Enum.map(tokens_to_expire, & &1.id))
        )

        {:ok, {super_admin, tokens_to_expire}}
      end
    end)
  end
end
