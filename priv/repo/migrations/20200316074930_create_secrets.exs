defmodule Tutorial.Repo.Migrations.CreateSecrets do
  use Ecto.Migration

  def change do
    create table(:secrets) do
      add :key, :string
      add :value, :string
      add :account_id, references(:accounts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:secrets, [:account_id])
  end
end
