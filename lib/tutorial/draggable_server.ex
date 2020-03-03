defmodule Tutorial.DraggableServer do
  use GenServer

  alias Tutorial.PubSub

  @default_coordinates {10, 10}

  def init(_opts) do
    Phoenix.PubSub.subscribe(PubSub, "tutorial:presence")

    state = %{}
    {:ok, state}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def subscribe(session_id), do: Phoenix.PubSub.subscribe(PubSub, "draggable:#{session_id}")

  def set_coordinates(session_id, coordinates) do
    GenServer.cast(__MODULE__, {:set_coordinates, session_id, coordinates})
  end

  def get_coordinates(session_id) do
    GenServer.call(__MODULE__, {:get_cordinates, session_id})
  end

  # Internal interface

  def handle_cast({:set_coordinates, session_id, coordinates}, state) do
    Phoenix.PubSub.broadcast(PubSub, "draggable:#{session_id}", {:updated_coordinates, coordinates})
    {:noreply, Map.put(state, session_id, coordinates)}
  end

  def handle_call({:get_cordinates, session_id}, _from, state) do
    {:reply, Map.get(state, session_id, @default_coordinates), state}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, state) do
    state =
      state
      |> handle_leaves(diff.leaves)

    {:noreply, state}
  end

  defp handle_leaves(state, leaves) do
    Enum.reduce(leaves, state, fn {session_id, _}, state ->
      Tutorial.Presence.list("tutorial:presence")
      |> Map.get(session_id)
      |> case do
        nil -> Map.delete(state, session_id)
        _ -> state
      end
    end)
  end
end
