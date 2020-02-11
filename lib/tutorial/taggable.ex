defmodule Tutorial.Taggable do
  @moduledoc """
  The Taggable context.
  """

  import Ecto.Query, warn: false
  alias Tutorial.Repo

  alias Tutorial.Taggable.Tag
  alias Tutorial.Taggable.Tagging

  def list_tags do
    Repo.all(Tag)
  end

  def tag_product(product, %{tag: tag_attrs} = attrs) do
    tag = create_or_find_tag(tag_attrs)

    product
    |> Ecto.build_assoc(:taggings)
    |> Tagging.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tag, tag)
    |> Repo.insert()
  end

  defp create_or_find_tag(%{name: "" <> name} = attrs) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, tag} -> tag
      _ -> Repo.get_by(Tag, name: name)
    end
  end
  defp create_or_find_tag(_), do: nil

  def delete_tag_from_product(product, tag) do
    Repo.get_by(Tagging, product_id: product.id, tag_id: tag.id)
    |> case do
      %Tagging{} = tagging -> Repo.delete(tagging)
      nil -> {:ok, %Tagging{}}
    end
  end
end
