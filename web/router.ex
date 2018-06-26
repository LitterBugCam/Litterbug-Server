defmodule Streaming.Router do
  use Streaming.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


    #pipe_through :browser # Use the default browser stack
    pipeline :admin_required do
      plug Streaming.CheckAdmin

    end
    pipeline :auth do
      plug Streaming.Auth.Pipeline
    end
    pipeline :ensure_auth do
      plug Guardian.Plug.EnsureAuthenticated
    end
    # Maybe logged in scope
      scope "/", Streaming do
      pipe_through [:browser, :auth]
      get "/", DeviceController, :index
      post "/", DeviceController, :login_global
      get "/signup", DeviceController, :register
      get "/admin", DeviceController, :admin_login
      post "/admin", DeviceController, :login_global
      get "/admin/devices_users", DeviceController, :index_admin
      #resources "/devices", DeviceController

    end
      # Definitely logged in scope
      scope "/", Streaming do
        pipe_through [:browser, :auth, :ensure_auth]
        get "/devices/new", DeviceController, :new
        post "/devices", DeviceController, :create
    #    get "/devices/:id", DeviceController, :show
        get "/devices",  DeviceController, :index
    #    get "/devices/edit/:id",DeviceController, :edit
      #  post "/devices/delete/:id",DeviceController, :delete
      get "/logout", DeviceController, :logout
      post "/devices/:id", DeviceController, :upload
      get "/:id/events", DeviceController, :show
      get "/wiki", DeviceController, :wiki

      get "/devices/edit/:id", DeviceController, :edit
      get "/myaccount" ,DeviceController, :myaccount
        put "/devices/:id", DeviceController, :update
        post "/event/", StreamController, :create_event
        get "/event", StreamController, :event
        resources "/", DeviceController

      end


  # Other scopes may use custom stacks.
  # scope "/api", Streaming do
  #   pipe_through :api
  # end
end
