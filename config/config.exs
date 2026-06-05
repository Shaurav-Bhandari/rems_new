# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Scopes — both defined in a single block to avoid the second overwriting the first
config :bindu_backend, :scopes,
  super_admin: [
    default: false,
    module: BinduBackend.SuperAdmins.Scope,
    assign_key: :current_scope,
    access_path: [:super_admin, :id],
    schema_key: :super_admin_id,
    schema_type: :id,
    schema_table: :super_admins,
    test_data_fixture: BinduBackend.SuperAdminsFixtures,
    test_setup_helper: :register_and_log_in_super_admin
  ],
  user: [
    default: true,
    module: BinduBackend.Accounts.Scope,
    assign_key: :current_scope,
    access_path: [:user, :id],
    schema_key: :user_id,
    schema_type: :id,
    schema_table: :users,
    test_data_fixture: BinduBackend.AccountsFixtures,
    test_setup_helper: :register_and_log_in_user
  ]

config :bindu_backend,
  ecto_repos: [BinduBackend.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :bindu_backend, BinduBackendWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BinduBackendWeb.ErrorHTML, json: BinduBackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: BinduBackend.PubSub,
  live_view: [signing_salt: "iuR6wT2N"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :bindu_backend, BinduBackend.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  bindu_backend: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.7",
  bindu_backend: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Multi-tenancy via Triplex
# - tenant_prefix: each tenant's Postgres schema will be named e.g. "tenant_acme"
# - reserved_tenants: prevents Triplex from creating/migrating system schemas
config :triplex,
  repo: BinduBackend.Repo,
  tenant_prefix: "tenant_",
  reserved_tenants: ["public", "information_schema", "pg_catalog", "pg_toast"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bindu_backend, :super_admin_email, "shauravbhandari2@gmail.com"

config :bindu_backend, Oban,
  repo: BinduBackend.Repo,
  plugins: [
    # keep 7 days
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
    {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)}
  ],
  queues: [
    default: 10,
    # low concurrency — DB-heavy work
    tenant_provisioning: 3
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
