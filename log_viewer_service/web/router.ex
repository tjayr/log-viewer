defmodule LogViewer.Router do
  use LogViewer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end


  pipeline :api do
    plug CORSPlug, [origin: "http://localhost:8000"]
    plug :accepts, ["json"]
  end

  scope "/", LogViewer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/show", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", LogViewer do
  #   pipe_through :api
  # end
end
