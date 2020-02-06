defmodule TutorialWeb.ProductFormLive do
  use Phoenix.LiveView

  alias Tutorial.Products
  alias Tutorial.Products.Product
  alias Tutorial.Products.Variant

  def mount(%{"action" => action, "csrf_token" => csrf_token} = session, socket) do
    product = get_product(session)
    changeset =
      Products.change_product(product)
      |> Ecto.Changeset.put_assoc(:variants, product.variants)

    assigns = [
      conn: socket,
      action: action,
      csrf_token: csrf_token,
      changeset: changeset,
      product: product
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    TutorialWeb.ProductView.render("form.html", assigns)
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Product.changeset(product_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("add-variant", _, socket) do
    vars = Map.get(socket.assigns.changeset.changes, :variants, socket.assigns.product.variants)

    variants =
      vars
      |> Enum.concat([
        Products.change_variant(%Variant{temp_id: get_temp_id()})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:variants, variants)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-variant", %{"remove" => remove_id}, socket) do
    variants =
      socket.assigns.changeset.changes.variants
      |> Enum.reject(fn %{data: variant} ->
        variant.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:variants, variants)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def get_product(%{"id" => id} = _product_params), do: Products.get_product!(id)
  def get_product(_product_params), do: %Product{variants: []}

  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5)
end
