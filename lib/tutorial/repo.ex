defmodule Tutorial.Repo do
  use Ecto.Repo,
    otp_app: :tutorial,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
