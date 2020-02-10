defmodule TutorialWeb.PageControllerTest do
  use TutorialWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Fullstack Phoenix"
  end
end
