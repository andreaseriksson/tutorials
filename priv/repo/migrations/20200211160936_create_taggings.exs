defmodule Tutorial.Repo.Migrations.CreateTaggings do
  use Ecto.Migration

  def change do
    create table(:taggings) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps()
    end

    create index(:taggings, [:tag_id])
    create index(:taggings, [:product_id])
    create unique_index(:taggings, [:tag_id, :product_id])
  end
end
