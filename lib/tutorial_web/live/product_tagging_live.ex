defmodule TutorialWeb.ProductTaggingLive do
  use Phoenix.LiveView

  alias Tutorial.{Repo, Products, Taggable}

  def mount(%{"id" => product_id} = _session, socket) do
    product = get_product(product_id, connected?(socket))

    assigns = [
      conn: socket,
      product: product,
      taggings: sorted(product.taggings),
      tags: [],
      search_results: [],
      search_phrase: "",
      current_focus: -1
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    TutorialWeb.ProductView.render("product_tagging.html", assigns)
  end

  def handle_event("search", %{"search_phrase" => search_phrase}, socket) do
    tags = if socket.assigns.tags == [], do: Taggable.list_tags, else: socket.assigns.tags

    assigns = [
      tags: tags,
      search_results: search(tags, search_phrase),
      search_phrase: search_phrase
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick", %{"name" => search_phrase}, socket) do
    product = socket.assigns.product
    taggings = add_tagging_to_product(product, search_phrase)

    assigns = [
      taggings: sorted(taggings),
      tags: [],
      search_results: [],
      search_phrase: ""
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("delete", %{"tagging" => tagging_id}, socket) do
    taggings = delete_tagging_from_product(socket.assigns, tagging_id)

    assigns = [
      taggings: taggings
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("submit", _, socket), do: {:noreply, socket} # PREVENT FORM SUBMIT

  def handle_event("set-focus", %{"keyCode" => 38}, socket) do # UP
    current_focus =
      Enum.max([(socket.assigns.current_focus - 1), 0])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  def handle_event("set-focus", %{"keyCode" => 40}, socket) do # DOWN
    current_focus =
      Enum.min([(socket.assigns.current_focus + 1), (length(socket.assigns.search_results)-1)])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  def handle_event("set-focus", %{"keyCode" => 13}, socket) do # ENTER
    search_phrase =
      case Enum.at(socket.assigns.search_results, socket.assigns.current_focus) do
        "" <> search_phrase -> search_phrase # PICK ONE FROM THE DROP DOWN LIST
        _ -> socket.assigns.search_phrase # PICK ONE FROM INPUT FIELD
      end

    handle_event("pick", %{"name" => search_phrase}, socket)
  end

  # FALLBACK FOR NON RELATED KEY STROKES
  def handle_event("set-focus", _, socket), do: {:noreply, socket}

  defp search(_, ""), do: []
  defp search(tags, search_phrase) do
    tags
    |> Enum.map(& &1.name)
    |> Enum.sort()
    |> Enum.filter(& matches?(&1, search_phrase))
  end

  defp matches?(first, second) do
    String.starts_with?(
      String.downcase(first), String.downcase(second)
    )
  end

  defp get_product(_, false), do: %{taggings: []}
  defp get_product(product_id, _) do
    Products.get_product!(product_id) |> Repo.preload(:tags)
  end

  defp add_tagging_to_product(product, search_phrase) do
    Taggable.tag_product(product, %{tag: %{name: search_phrase}})
    %{taggings: taggings} = get_product(product.id, true)

    taggings
  end

  defp delete_tagging_from_product(%{product: product, taggings: taggings}, tagging_id) do
    taggings
    |> Enum.reject(fn tagging ->
      if "#{tagging.id}" == tagging_id do
        Taggable.delete_tag_from_product(product, tagging.tag)
        true
      else
        false
      end
    end)
  end

  defp sorted(taggings), do: Enum.sort_by(taggings, &(&1.id)) # MAKE SURE THE TAGS ARE ALWAYS SORTED BY ASC ORDER
end
