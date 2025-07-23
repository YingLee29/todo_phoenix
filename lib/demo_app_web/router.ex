defmodule DemoAppWeb.Router do
  use DemoAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DemoAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DemoAppWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Authentication routes (no auth required)
  scope "/", DemoAppWeb do
    pipe_through [:browser, :require_unauthenticated_user]

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
  end

  # Public routes
  scope "/", DemoAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    delete "/logout", SessionController, :delete
  end

  # Protected routes (authentication required)
  scope "/", DemoAppWeb do
    pipe_through [:browser, :require_authenticated_user]

    resources "/users", UserController
    resources "/products", ProductController
    resources "/stores", StoreController
  end

  # Other scopes may use custom stacks.
  # scope "/api", DemoAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:demo_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DemoAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp require_authenticated_user(conn, _opts) do
    DemoAppWeb.Plugs.Auth.require_authenticated_user(conn, _opts)
  end

  defp require_unauthenticated_user(conn, _opts) do
    DemoAppWeb.Plugs.Auth.require_unauthenticated_user(conn, _opts)
  end
end
