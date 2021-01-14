defmodule Waldon.Repo do
  use Ecto.Repo,
    otp_app: :waldon,
    adapter: Ecto.Adapters.Postgres
end
