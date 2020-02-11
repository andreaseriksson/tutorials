defmodule Tutorial.Taggable.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taggings" do
    belongs_to :tag, Tutorial.Taggable.Tag
    belongs_to :product, Tutorial.Products.Product

    timestamps()
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [])
    |> unique_constraint(:name, name: :taggings_tag_id_product_id_index)
    |> cast_assoc(:tag)
  end
end
