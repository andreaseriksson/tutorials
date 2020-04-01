defmodule TutorialWeb.ModalComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    {:ok, assign(socket, state: "CLOSED", action: nil)}
  end

  def render(assigns) do
    if assigns.state == "OPEN" do
      ~L"""
      <div
        id="<%= @id %>"
        phx-hook="initModal"
        x-data="{ open: false }"
        x-init="() => {
          setTimeout(() => open = true, 100);
          $watch('open', isOpen => $dispatch('modal-change', { open: isOpen }))
        }"
        x-show="open"
        @close-modal="setTimeout(() => open = false, 100)"
        class="z-50 fixed bottom-0 inset-x-0 px-4 pb-4 sm:inset-0 sm:flex sm:items-center sm:justify-center"
      >
        <%= if @action == "CLOSE" do %>
          <div id="close-modal-<%= @id %>" data-modal-id="<%= @id %>" phx-hook="closeModal"></div>
        <% end %>

        <!-- BACKDROP -->
        <div x-show="open" x-transition:enter="ease-out duration-300" x-transition:enter-start="opacity-0" x-transition:enter-end="opacity-100" x-transition:leave="ease-in duration-200" x-transition:leave-start="opacity-100" x-transition:leave-end="opacity-0" class="fixed inset-0 transition-opacity">
          <div class="absolute inset-0 bg-gray-800 opacity-75"></div>
        </div>

        <div x-show="open" x-transition:enter="ease-out duration-300" x-transition:enter-start="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95" x-transition:enter-end="opacity-100 translate-y-0 sm:scale-100" x-transition:leave="ease-in duration-200" x-transition:leave-start="opacity-100 translate-y-0 sm:scale-100" x-transition:leave-end="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95" class="bg-white rounded-lg overflow-hidden shadow-xl transform transition-all sm:max-w-lg sm:w-full">
          <div @click.away="open = false" class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div class="hidden sm:block absolute top-0 right-0 pt-4 pr-4">
              <button type="button" @click="open = false" class="text-gray-400 hover:text-gray-500 focus:outline-none focus:text-gray-500 transition ease-in-out duration-150">
                <svg class="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
              </button>
            </div>
            <!-- CONTENT -->
            <%= @inner_content.([]) %>
          </div>
        </div>
      </div>
      """
    else
     ~L"""
     <div id="closed-modal-<%= @id %>"></div>
     """
    end
  end
end
