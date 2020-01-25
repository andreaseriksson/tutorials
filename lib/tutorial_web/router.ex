defmodule TutorialWeb.Router do
  use TutorialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TutorialWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/products", ProductController
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
