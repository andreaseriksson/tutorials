defmodule TutorialWeb.Router do
  use TutorialWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TutorialWeb.GenerateCSRF
    plug TutorialWeb.AssignSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", TutorialWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/draggable", PageController, :draggable
    get "/task_async", PageController, :task_async

    live "/products", ProductListLive # NEEDS TO BE ABOVE
    resources "/products", ProductController
  end

  scope "/", TutorialWeb do
    pipe_through [:protected, :browser]

    get "private", PageController, :private
  end

  # Other scopes may use custom stacks.
  # scope "/api", TutorialWeb do
  #   pipe_through :api
  # end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :tutorial, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Tutorial App - Fullstack Phoenix"
      }
    }
  end
end
