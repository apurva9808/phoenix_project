defmodule BookClub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BookClubWeb.Telemetry,
      BookClub.Repo,
      {DNSCluster, query: Application.get_env(:book_club, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BookClub.PubSub},
      # Start a worker by calling: BookClub.Worker.start_link(arg)
      # {BookClub.Worker, arg},
      # Start to serve requests, typically the last entry
      BookClubWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BookClub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BookClubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
