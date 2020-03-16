defmodule Tutorial.Secrets.Secret do
  use Ecto.Schema
  import Ecto.Changeset

  schema "secrets" do
    field :key, :string
    field :value, :string

    belongs_to :account, Tutorial.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(secret, attrs) do
    secret
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
