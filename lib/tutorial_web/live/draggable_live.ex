defmodule TutorialWeb.DraggableLive do
  use Phoenix.LiveView

  alias Tutorial.DraggableServer
  alias Tutorial.Presence

  def mount(%{"session_id" => session_id}, socket) do
    if connected?(socket) do
      # As soon as a new instance if the LiveView is mounted, track the session id
      {:ok, _} = Presence.track(self(), "tutorial:presence", session_id, %{
        session_id: session_id,
        joined_at: :os.system_time(:seconds)
      })

      DraggableServer.subscribe(session_id)
    end

    {x, y} = DraggableServer.get_coordinates(session_id)

    assigns = [
      x: x,
      y: y,
      session_id: session_id
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~L"""
    <div style="transform: translate(<%= @x %>px, <%= @y %>px);"
      phx-hook="Draggable" class="item h-20 w-20 border border-gray-500 bg-blue-200 shadow"></div>
    """
  end

  def handle_event("moving", %{"x" => x, "y" => y}, socket) do
    coordinates = {socket.assigns.x + x, socket.assigns.y + y}
    DraggableServer.set_coordinates(socket.assigns.session_id, coordinates)
    {:noreply, socket}
  end

  def handle_info({:updated_coordinates, {x, y}}, socket) do
    assigns = [
      x: x,
      y: y
    ]

    {:noreply, assign(socket, assigns)}
  end
end
