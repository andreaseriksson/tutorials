defmodule Tutorial.Worker do
  use Task, restart: :transient

  alias Tutorial.PubSub
  @topic inspect(__MODULE__)

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    :timer.sleep(2000)
    number = Enum.random(0..3)

    if number == 1 do
      IO.puts "CRASH"
      raise inspect(number)
    end

    number
    |> notify_subscribers()
  end

  defp notify_subscribers(number) do
    Phoenix.PubSub.broadcast(PubSub, @topic, {:message, number})
  end

  def subscribe do
    Phoenix.PubSub.subscribe(PubSub, @topic)
  end
end
