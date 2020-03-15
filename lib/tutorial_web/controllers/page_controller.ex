defmodule TutorialWeb.PageController do
  use TutorialWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def draggable(conn, _params) do
    render(conn, "draggable.html")
  end

  def task_async(conn, _params) do
    render(conn, "task_async.html")
  end

  def private(conn, _params) do
    render(conn, "private.html")
  end
end
