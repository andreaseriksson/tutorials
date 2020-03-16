defmodule TutorialWeb.Plugs.SetCurrentAccount do
  import Plug.Conn, only: [assign: 3]

  alias Tutorial.Repo
  alias Tutorial.Users.User

  def init(options), do: options

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      %User{} = user ->
        %User{account: account} = Repo.preload(user, :account)
        assign(conn, :current_account, account)
      _ ->
        assign(conn, :current_account, nil)
    end
  end
end
