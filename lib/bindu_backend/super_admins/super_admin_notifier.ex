defmodule BinduBackend.SuperAdmins.SuperAdminNotifier do
  import Swoosh.Email

  alias BinduBackend.Mailer
  alias BinduBackend.SuperAdmins.SuperAdmin

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"BinduBackend", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to update a super_admin email.
  """
  def deliver_update_email_instructions(super_admin, url) do
    deliver(super_admin.email, "Update email instructions", """

    ==============================

    Hi #{super_admin.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to log in with a magic link.
  """
  def deliver_login_instructions(super_admin, url) do
    case super_admin do
      %SuperAdmin{confirmed_at: nil} -> deliver_confirmation_instructions(super_admin, url)
      _ -> deliver_magic_link_instructions(super_admin, url)
    end
  end

  defp deliver_magic_link_instructions(super_admin, url) do
    deliver(super_admin.email, "Log in instructions", """

    ==============================

    Hi #{super_admin.email},

    You can log into your account by visiting the URL below:

    #{url}

    If you didn't request this email, please ignore this.

    ==============================
    """)
  end

  defp deliver_confirmation_instructions(super_admin, url) do
    deliver(super_admin.email, "Confirmation instructions", """

    ==============================

    Hi #{super_admin.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end
end
