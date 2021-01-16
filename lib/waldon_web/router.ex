defmodule WaldonWeb.Router do
  use WaldonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WaldonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WaldonWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/properties", PropertyLive.Index, :index
    live "/properties/new", PropertyLive.Index, :new
    live "/properties/:id/edit", PropertyLive.Index, :edit

    live "/properties/:id", PropertyLive.Show, :show
    live "/properties/:id/show/edit", PropertyLive.Show, :edit
    # new Unit
    live "/properties/:id/units/new", PropertyLive.Show, :new
    live "/properties/:id/units/:uid/edit", PropertyLive.Show, :edit_unit
    live "/properties/:id/units/:uid", PropertyLive.UnitShow, :show
    live "/properties/:id/units/:uid/show/edit", PropertyLive.UnitShow, :edit_unit

    live "/tenants", TenantLive.Index, :index
    live "/tenants/new", TenantLive.Index, :new
    live "/tenants/:id/edit", TenantLive.Index, :edit

    live "/tenants/:id", TenantLive.Show, :show
    live "/tenants/:id/show/edit", TenantLive.Show, :edit

    live "/leases", LeaseLive.Index, :index
    live "/leases/new", LeaseLive.Index, :new
    live "/leases/:id/edit", LeaseLive.Index, :edit

    live "/leases/:id", LeaseLive.Show, :show
    live "/leases/:id/show/edit", LeaseLive.Show, :edit

    live "/demo", DemoLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", WaldonWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: WaldonWeb.Telemetry
    end
  end
end
