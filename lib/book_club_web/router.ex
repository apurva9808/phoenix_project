defmodule BookClubWeb.Router do
  use BookClubWeb, :router

  import BookClubWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BookClubWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BookClubWeb do
    pipe_through :browser

    # Change this line from PageController to HomeController
    get "/", HomeController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookClubWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:book_club, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BookClubWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BookClubWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BookClubWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
      
      # Book routes
      live "/books", BookLive.Index, :index
      live "/books/new", BookLive.Form, :new
      live "/books/:id", BookLive.Show, :show
      live "/books/:id/edit", BookLive.Form, :edit
      
      # Reading List routes
      live "/reading_lists", ReadingListLive.Index, :index
      live "/reading_lists/new", ReadingListLive.Form, :new
      live "/reading_lists/:id", ReadingListLive.Show, :show
      live "/reading_lists/:id/edit", ReadingListLive.Form, :edit
      
      # Review routes
      live "/reviews", ReviewLive.Index, :index
      live "/reviews/new", ReviewLive.Form, :new
      live "/reviews/:id", ReviewLive.Show, :show
      live "/reviews/:id/edit", ReviewLive.Form, :edit
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", BookClubWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{BookClubWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end