defmodule Tutorial.TaggableTest do
  use Tutorial.DataCase

  alias Tutorial.Taggable
  alias Tutorial.Taggable.Tag
  alias Tutorial.Taggable.Tagging
  alias Tutorial.Repo
  alias Tutorial.Products

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{description: "some description", name: "some name", price: 120.5, properties: %{}})
      |> Products.create_product()

    product
  end

  def tag_fixture() do
    product = product_fixture()

    {:ok, %Tagging{tag: tag}} =
      Taggable.tag_product(product, %{tag: %{name: "Stout"}})

    tag
  end

  describe "tags and taggings" do
    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Taggable.list_tags() == [tag]
    end

    test "tag_product/2 with valid data creates a tag" do
      product = product_fixture()
      assert {:ok, %Tagging{} = tagging} = Taggable.tag_product(product, %{tag: %{name: "Stout"}})
      assert tagging.tag.name == "Stout"
    end

    test "tag_product/2 with valid data appends the tag if it exists" do
      product = product_fixture()
      tag = tag_fixture()
      Taggable.delete_tag_from_product(product, tag)

      assert {:ok, %Tagging{} = tagging} = Taggable.tag_product(product, %{tag: %{name: "Stout"}})
      assert tagging.tag.name == "Stout"
    end

    test "tag_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Taggable.tag_product(product, %{tag: %{name: nil}})
    end

    test "tag_product/2 with duplicate tag returns error changeset" do
      product = product_fixture()
      Taggable.tag_product(product, %{tag: %{name: "Stout"}})
      assert {:error, %Ecto.Changeset{}} = Taggable.tag_product(product, %{tag: %{name: "Stout"}})
    end

    test "delete_tag_from_product/2 deletes the tagging from product but not the tag" do
      product = product_fixture()
      {:ok, %Tagging{tag: %Tag{} = tag}} = Taggable.tag_product(product, %{tag: %{name: "Lager"}})

      assert %{tags: [^tag]} = product |> Repo.preload(:tags)
      assert {:ok, %Tagging{}} = Taggable.delete_tag_from_product(product, tag)
      assert %{tags: []} = product |> Repo.preload(:tags)
      assert [%Tag{name: "Lager"}] = Taggable.list_tags()
    end
  end
end
