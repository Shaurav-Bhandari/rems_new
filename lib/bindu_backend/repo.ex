defmodule BinduBackend.Repo do
  use Ecto.Repo,
    otp_app: :bindu_backend,
    adapter: Ecto.Adapters.Postgres
end
