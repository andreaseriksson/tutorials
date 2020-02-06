defmodule Tutorial.Products.Variant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "variants" do
    field :name, :string
    field :value, :string
    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true

    belongs_to :product, Tutorial.Products.Product

    timestamps()
  end

  @doc false
  def changeset(variant, attrs) do
    variant
    |> Map.put(:temp_id, (variant.temp_id || attrs["temp_id"]))
    |> cast(attrs, [:name, :value, :delete])
    |> validate_required([:name, :value])
    |> unique_constraint(:name, name: :variants_name_value_product_id_index)
    |> maybe_mark_for_deletion
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset
  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
