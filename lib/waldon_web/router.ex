defmodule WaldonWeb.Router do
  use WaldonWeb, :router

  import WaldonWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WaldonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # pipeline :api do
  #  plug :accepts, ["json"]
  # end

  scope "/", WaldonWeb do
    pipe_through [:browser, :require_authenticated_user]

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

  ## Authentication routes

  scope "/", WaldonWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", WaldonWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", WaldonWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
