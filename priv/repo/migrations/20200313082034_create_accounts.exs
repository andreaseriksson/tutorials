defmodule Tutorial.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:accounts, [:name])
  end
end
