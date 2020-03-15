defmodule Tutorial.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    timestamps()
  end
end
