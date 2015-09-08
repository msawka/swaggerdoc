defmodule HelloUser.Router do
  use HelloUser.Web, :router

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

  scope "/", HelloUser do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/users", HelloUser do
    pipe_through :api

    get "/", UserController, :index
    post "/", UserController, :create

    get "/:id", UserController, :show
    put "/:id", UserController, :update
    delete "/:id", UserController, :destroy

    post "/:id/sync", UserController, :sync_user
    get "/:id/fields", UserController, :get_custom_fields
  end  
end
