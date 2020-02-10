defmodule Tutorial.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :float
    field :properties, :map
    has_many :variants, Tutorial.Products.Variant

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :properties])
    |> cast_assoc(:variants)
    |> validate_required([:name, :description, :price])
    |> validate_length(:name, min: 2)
    |> validate_number(:price, greater_than: 0)
  end
end
