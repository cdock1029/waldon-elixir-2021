defmodule Waldon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Waldon.Repo,
      # Start the Telemetry supervisor
      WaldonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Waldon.PubSub},
      # Start the Endpoint (http/https)
      WaldonWeb.Endpoint
      # Start a worker by calling: Waldon.Worker.start_link(arg)
      # {Waldon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Waldon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WaldonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
