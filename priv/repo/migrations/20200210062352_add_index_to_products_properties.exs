defmodule Tutorial.Repo.Migrations.AddIndexToProductsProperties do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX products_properties ON products USING GIN(properties)")
  end

  def down do
    execute("DROP INDEX products_properties")
  end
end
