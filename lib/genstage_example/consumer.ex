defmodule GenstageExample.Consumer do
  use GenStage

  require Logger

  def start_link do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    {:consumer, nil, subscribe_to: [{GenstageExample.Producer, max_demand: 1}]}
  end

  def handle_events(events, _from, state) do
    Logger.debug("+++++++++++++++++++++++")
    
    Logger.debug("consumer #{inspect(events)}")
    Process.sleep(3000)
    {:noreply, [], state}
  end
end