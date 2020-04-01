defmodule TutorialWeb.ModalsLive do
  use Phoenix.LiveView

  # MODAL
  def handle_event("submit", %{"id" => id}, socket) do
    send_update TutorialWeb.ModalComponent, id: id, action: "CLOSE"
    {:noreply, socket}
  end

  def handle_event("open-modal", %{"id" => id}, socket) do
    send_update TutorialWeb.ModalComponent, id: id, state: "OPEN"
    {:noreply, socket}
  end

  def handle_event("close-modal", %{"id" => id}, socket) do
    :timer.sleep(300) # SO THE CSS ANIMATIONS HAVE TIME TO RUN
    send_update TutorialWeb.ModalComponent, id: id, state: "CLOSED", action: nil
    {:noreply, socket}
  end
end
