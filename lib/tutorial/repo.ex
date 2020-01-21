defmodule Tutorial.Repo do
  use Ecto.Repo,
    otp_app: :tutorial,
    adapter: Ecto.Adapters.Postgres
end
