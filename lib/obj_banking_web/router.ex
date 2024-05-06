defmodule ObjBankingWeb.Router do
  use ObjBankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ObjBankingWeb do
    pipe_through :api
    post "/transacao", TransactionController, :register_transaction
    put "/conta", TransactionController, :update_balance
    post "/conta", AccountController, :create_account
    get "/conta", AccountController, :get_account
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:obj_banking, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ObjBankingWeb.Telemetry
    end
  end
end
