defmodule Tutorial.Repo.Migrations.AddPropertiesToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :properties, :map, default: %{}
    end
  end
end
