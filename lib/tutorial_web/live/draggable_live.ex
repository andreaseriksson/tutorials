defmodule TutorialWeb.DraggableLive do
  use Phoenix.LiveView

  def mount(%{}, socket) do
    assigns = [
      x: 10,
      y: 10
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~L"""
    <div style="transform: translate(<%= @x %>px, <%= @y %>px);" phx-hook="Draggable" class="item h-20 w-20 border border-gray-500 bg-blue-200 shadow"></div>
    """
  end

  def handle_event("moving", %{"x" => x, "y" => y}, socket) do
    assigns = [
      x: (socket.assigns.x || 0) + x,
      y: (socket.assigns.y || 0) + y
    ]

    {:noreply, assign(socket, assigns)}
  end
end
