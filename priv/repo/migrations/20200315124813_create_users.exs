defmodule Tutorial.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :account_id, references(:accounts, on_delete: :delete_all), null: false

      add :email, :string, null: false
      add :password_hash, :string

      timestamps()
    end

    create index(:users, [:account_id])
    create unique_index(:users, [:email])
  end
end
