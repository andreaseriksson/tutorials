defmodule TutorialWeb.AppChannel do
  use TutorialWeb, :channel

  def join("app:" <> token, _payload, socket) do
    {:ok, assign(socket, :channel, "app:#{token}")}
  end

  # can be triggered by from the frontend js by:
  # channel.push('paginate', message)
  def handle_in("paginate", payload, socket) do
    Phoenix.PubSub.broadcast(Tutorial.PubSub, socket.assigns.channel, {"paginate", payload})
    {:noreply, socket}
  end

  def handle_info(_, socket), do: {:noreply, socket}
end
