# lib/bindu_backend/mailer.ex

defmodule BinduBackend.Mailer do
  use Swoosh.Mailer, otp_app: :bindu_backend

  import Swoosh.Email

  @from_email "noreply@bindubackend.com"
  @from_name  "Bindu RMS"

  @doc """
  Sends a welcome email to the new tenant owner with their temporary password.
  Called after seed_admin_user/1 succeeds.
  """
  def send_tenant_welcome(to_email, owner_name, temp_password) do
    new()
    |> to({owner_name, to_email})
    |> from({@from_name, @from_email})
    |> subject("Welcome to Bindu RMS — Your Restaurant is Being Set Up")
    |> html_body(welcome_html(owner_name, temp_password))
    |> text_body(welcome_text(owner_name, temp_password))
    |> deliver()
  end

  @doc """
  Notifies super admin when tenant provisioning fails after all retries.
  """
  def send_provisioning_failure_alert(tenant_id, slug, step, reason) do
    new()
    |> to({"Bindu Super Admin", superadmin_email()})
    |> from({@from_name, @from_email})
    |> subject("[ALERT] Tenant Provisioning Failed — #{slug}")
    |> html_body(failure_html(tenant_id, slug, step, reason))
    |> text_body(failure_text(tenant_id, slug, step, reason))
    |> deliver()
  end

  # ── Email bodies ──────────────────────────────────────────────────────────

  defp welcome_html(owner_name, temp_password) do
    """
    <html>
      <body style="font-family: sans-serif; color: #1f2937; padding: 32px;">
        <h2 style="color: #dc2626;">Welcome to Bindu RMS, #{owner_name}!</h2>
        <p>Your restaurant is being set up. This usually takes less than a minute.</p>
        <p>Here are your temporary login credentials:</p>
        <table style="background: #f3f4f6; padding: 16px; border-radius: 8px;">
          <tr>
            <td><strong>Email:</strong></td>
          </tr>
          <tr>
            <td style="font-family: monospace; font-size: 16px; padding: 8px 0;">#{temp_password}</td>
          </tr>
        </table>
        <p style="color: #ef4444;">
          <strong>Please change your password immediately after your first login.</strong>
        </p>
        <p>If you did not sign up for Bindu RMS, please ignore this email or contact support.</p>
        <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 24px 0;" />
        <p style="color: #6b7280; font-size: 12px;">Bindu RMS — Restaurant Management for Nepal</p>
      </body>
    </html>
    """
  end

  defp welcome_text(owner_name, temp_password) do
    """
    Welcome to Bindu RMS, #{owner_name}!

    Your restaurant is being set up. This usually takes less than a minute.

    Your temporary password is: #{temp_password}

    Please change your password immediately after your first login.

    If you did not sign up for Bindu RMS, please ignore this email.
    """
  end

  defp failure_html(tenant_id, slug, step, reason) do
    """
    <html>
      <body style="font-family: sans-serif; color: #1f2937; padding: 32px;">
        <h2 style="color: #dc2626;">[ALERT] Tenant Provisioning Failed</h2>
        <table style="border-collapse: collapse; width: 100%;">
          <tr>
            <td style="padding: 8px; border: 1px solid #e5e7eb;"><strong>Tenant ID</strong></td>
            <td style="padding: 8px; border: 1px solid #e5e7eb;">#{tenant_id}</td>
          </tr>
          <tr>
            <td style="padding: 8px; border: 1px solid #e5e7eb;"><strong>Slug</strong></td>
            <td style="padding: 8px; border: 1px solid #e5e7eb;">#{slug}</td>
          </tr>
          <tr>
            <td style="padding: 8px; border: 1px solid #e5e7eb;"><strong>Failed Step</strong></td>
            <td style="padding: 8px; border: 1px solid #e5e7eb;">#{step}</td>
          </tr>
          <tr>
            <td style="padding: 8px; border: 1px solid #e5e7eb;"><strong>Reason</strong></td>
            <td style="padding: 8px; border: 1px solid #e5e7eb;">#{reason}</td>
          </tr>
        </table>
        <p>Log in to the super admin panel to retry or rollback this tenant.</p>
      </body>
    </html>
    """
  end

  defp failure_text(tenant_id, slug, step, reason) do
    """
    [ALERT] Tenant Provisioning Failed

    Tenant ID   : #{tenant_id}
    Slug        : #{slug}
    Failed Step : #{step}
    Reason      : #{reason}

    Log in to the super admin panel to retry or rollback this tenant.
    """
  end

  defp superadmin_email do
    Application.get_env(:bindu_backend, :super_admin_email, "shauravbhandari2@gmail.com")
  end
end
