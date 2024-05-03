defmodule ObjBaking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ObjBakingWeb.Telemetry,
      ObjBaking.Repo,
      {DNSCluster, query: Application.get_env(:obj_baking, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ObjBaking.PubSub},
      # Start a worker by calling: ObjBaking.Worker.start_link(arg)
      # {ObjBaking.Worker, arg},
      # Start to serve requests, typically the last entry
      ObjBakingWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ObjBaking.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ObjBakingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
