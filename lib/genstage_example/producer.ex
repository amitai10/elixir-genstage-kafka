defmodule GenstageExample.Producer do
  use GenStage
  require IEx
  require Logger

  def start_link() do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]), do: {:producer,  %{demand: 0, message_set: [], from: __MODULE__}}

  def notify(message_set, timeout \\ 5000) do
    Logger.debug "111111"
    GenStage.call(__MODULE__, {:notify, message_set}, timeout)
  end

  def handle_call({:notify, message_set}, from, %{demand: 0} = state) do
    Logger.debug "222222"
    
    {:noreply, [], %{state | message_set: message_set, from: from}}
  end

  def handle_call({:notify, message_set}, from, %{demand: demand} = state) when length(message_set) > demand do
    Logger.debug "333333"
    
    {to_dispatch, remaining} = Enum.split(message_set, demand)
    to_dispatch = Enum.map(to_dispatch, &"#{&1.value}, demand: #{demand}")
    new_state = %{state | message_set: remaining, from: from, demand: demand - length(to_dispatch)}
    {:noreply, to_dispatch, new_state}
  end

  def handle_call({:notify, message_set}, from, %{demand: demand} = state) do
    Logger.debug "4444444"
    
    to_dispatch = Enum.map(message_set, &"#{&1.value}, demand: #{demand}")
    new_state = %{state | demand: demand - length(to_dispatch), from: from}
    {:reply, :ok, to_dispatch, new_state}
  end

  def handle_call({:notify, message_set}, _from, state) do
    Logger.debug "55555555"
    {:noreply, message_set, state}
  end



  def handle_demand(demand, %{message_set: []} = state) when demand > 0 do
    Logger.debug "666666666666"
    
    {:noreply, [], %{state | demand: demand}}
  end

  def handle_demand(demand, %{message_set: message_set} = state) when demand > 0 and length(message_set) > demand do
    Logger.debug "77777777777777777"
    
    {to_dispatch, remaining} = Enum.split(message_set, demand)
    to_dispatch = Enum.map(to_dispatch, &"#{&1.value}")
    {:noreply, to_dispatch, %{state | message_set: remaining, demand: 0}}
  end

  def handle_demand(demand, %{message_set: message_set} = state) when demand > 0 do
    Logger.debug "888888888888888888"
    
    to_dispatch = Enum.map(message_set, &"#{&1.value}")
    new_state = %{state | message_set: [], demand: demand - length(to_dispatch)}
    GenStage.reply(state.from, :ok)
    {:noreply, to_dispatch, new_state}
  end

  def handle_demand(demand, state) do
    Logger.debug "99999999999999999"
    {:noreply, [], state}
  end
end