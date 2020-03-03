defmodule TutorialWeb.AssignSession do
  import Plug.Conn, only: [get_session: 2, put_session: 3]

  def init(options), do: options

  def call(conn, _opts) do
    case get_session(conn, :session_id) do
      nil -> put_session(conn, :session_id, Ecto.UUID.generate())
      _ -> conn
    end
  end
end
