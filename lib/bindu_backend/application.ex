defmodule BinduBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BinduBackendWeb.Telemetry,
      BinduBackend.Repo,
      {DNSCluster, query: Application.get_env(:bindu_backend, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BinduBackend.PubSub},
      {Finch, name: BinduBackend.Finch},
      {Task.Supervisor, name: BinduBackend.TaskSupervisor},
      {Oban, Application.fetch_env!(:bindu_backend, Oban)},
      # Start a worker by calling: BinduBackend.Worker.start_link(arg)
      # {BinduBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      BinduBackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BinduBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BinduBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
