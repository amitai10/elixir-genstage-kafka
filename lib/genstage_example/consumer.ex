defmodule GenstageExample.Consumer do
  use GenStage
  
  require IEx
  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    {:consumer, nil, subscribe_to: [{GenstageExample.Producer, max_demand: 2}]}
  end

  def handle_events(events, _from, state) do
    e_j = events 
    |> Enum.map(fn(e) -> Poison.decode!(e) end)
    Logger.debug("consumer #{inspect(e_j)}")
    Process.sleep(1000)
    {:noreply, [], state}
  end
end