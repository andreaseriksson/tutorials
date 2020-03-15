defmodule Tutorial.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :accounts_name_index)
  end
end
