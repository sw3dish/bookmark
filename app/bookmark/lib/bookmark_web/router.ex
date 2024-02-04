defmodule BookmarkWeb.Router do
  use BookmarkWeb, :router

  import BookmarkWeb.UserAuth

  def set_layout(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    Phoenix.Controller.put_layout(conn, html: {BookmarkWeb.Layouts, :unauthenticated})
  end

  def set_layout(%Plug.Conn{assigns: %{current_user: _current_user}} = conn, _opts) do
    Phoenix.Controller.put_layout(conn, html: {BookmarkWeb.Layouts, :app})
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BookmarkWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :set_layout
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_current_user
  end

  scope "/", BookmarkWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", LinkController, :index
    get "/links/favorites", LinkController, :favorites
    get "/links/to_read", LinkController, :to_read
    resources "/links", LinkController, except: [:index]
    resources "/imports", ImportController, except: [:edit, :update, :delete]
  end

  scope "/bookmarklet", BookmarkWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", BookmarkletController, :new
    post "/", BookmarkletController, :create
    get "/confirm", BookmarkletController, :confirm
  end

  scope "/api", BookmarkWeb.Api, as: :api do
    pipe_through :api

    resources "/links", LinkController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookmarkWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bookmark, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BookmarkWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BookmarkWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BookmarkWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", BookmarkWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BookmarkWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", BookmarkWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{BookmarkWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
