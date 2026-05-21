defmodule BinduBackendWeb.SuperAdminLive.Registration do
  use BinduBackendWeb, :live_view

  alias BinduBackend.SuperAdmins
  alias BinduBackend.SuperAdmins.SuperAdmin

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm">
        <div class="text-center">
          <.header>
            Register for an account
            <:subtitle>
              Already registered?
              <.link
                navigate={~p"/super_admins/log-in"}
                class="font-semibold text-brand hover:underline"
              >
                Log in
              </.link>
              to your account now.
            </:subtitle>
          </.header>
        </div>

        <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
          <.input
            field={@form[:email]}
            type="email"
            label="Email"
            autocomplete="username"
            spellcheck="false"
            required
            phx-mounted={JS.focus()}
          />

          <.button phx-disable-with="Creating account..." class="btn btn-primary w-full">
            Create an account
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{super_admin: super_admin}}} = socket)
      when not is_nil(super_admin) do
    {:ok, redirect(socket, to: BinduBackendWeb.SuperAdminAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = SuperAdmins.change_super_admin_email(%SuperAdmin{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"super_admin" => super_admin_params}, socket) do
    case SuperAdmins.register_super_admin(super_admin_params) do
      {:ok, super_admin} ->
        {:ok, _} =
          SuperAdmins.deliver_login_instructions(
            super_admin,
            &url(~p"/super_admins/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "An email was sent to #{super_admin.email}, please access it to confirm your account."
         )
         |> push_navigate(to: ~p"/super_admins/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"super_admin" => super_admin_params}, socket) do
    changeset =
      SuperAdmins.change_super_admin_email(%SuperAdmin{}, super_admin_params,
        validate_unique: false
      )

    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "super_admin")
    assign(socket, form: form)
  end
end
