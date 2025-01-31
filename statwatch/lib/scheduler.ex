defmodule Statwatch.Scheduler do
  use GenServer

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    handle_info(:work, state)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Statwatch.run()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, 5 * 1000)
  end
end
