defmodule TutorialWeb.PageController do
  use TutorialWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def draggable(conn, _params) do
    render(conn, "draggable.html")
  end
end
