defmodule Tutorial.Products.Variant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "variants" do
    field :name, :string
    field :value, :string
    belongs_to :product, Tutorial.Products.Product

    timestamps()
  end

  @doc false
  def changeset(variant, attrs) do
    variant
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
    |> unique_constraint(:name, name: :variants_name_value_product_id_index)
  end
end
