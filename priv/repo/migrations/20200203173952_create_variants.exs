defmodule Tutorial.Repo.Migrations.CreateVariants do
  use Ecto.Migration

  def change do
    create table(:variants) do
      add :name, :string, null: false
      add :value, :string, null: false
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps()
    end

    create index(:variants, [:product_id])
    create unique_index(:variants, [:name, :value, :product_id])
  end
end
