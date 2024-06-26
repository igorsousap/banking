defmodule ObjBanking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ObjBankingWeb.Telemetry,
      ObjBanking.Repo,
      {DNSCluster, query: Application.get_env(:obj_banking, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ObjBanking.PubSub},
      # Start a worker by calling: ObjBanking.Worker.start_link(arg)
      # {ObjBanking.Worker, arg},
      # Start to serve requests, typically the last entry
      ObjBankingWeb.Endpoint,
      {Oban, Application.fetch_env!(:obj_banking, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ObjBanking.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ObjBankingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
