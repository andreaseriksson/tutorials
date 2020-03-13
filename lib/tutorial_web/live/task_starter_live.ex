defmodule TutorialWeb.TaskStarterLive do
  use Phoenix.LiveView

  alias Tutorial.Worker

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Worker.subscribe()
    end

    assigns = [
      loading: false,
      result: nil
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~L"""
    <div class="mt-10">
      <button class="btn btn-primary" phx-click="start-task">Long running task that might crash</button>
    </div>
    <div class="mt-10">
      <%= if @result || @loading do %>
        <%= if @loading do %>
          <svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" class="css-i6dzq1">
            <circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline>
          </svg>
        <% else %>
          Result: <%= @result %>
        <% end %>
      <% end %>
    </div>
    """
  end

  def handle_event("start-task", _, socket) do
    Supervisor.start_link([{Worker, nil}], strategy: :one_for_one)

    assigns = [
      loading: true
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_info({:message, number}, socket) do
    assigns = [
      loading: false,
      result: number
    ]

    {:noreply, assign(socket, assigns)}
  end
end
