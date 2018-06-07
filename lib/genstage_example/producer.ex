defmodule GenstageExample.Producer do
  use GenStage
  require IEx
  require Logger

  def start_link() do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]), do: {:producer,  %{demand: 0, message_set: [], from: __MODULE__}}

  def notify(message_set, timeout \\ 150000) do
    GenStage.call(__MODULE__, {:notify, message_set}, timeout)
  end

  def handle_call({:notify, message_set}, from, %{demand: 0} = state) do
    {:noreply, [], %{state | message_set: message_set, from: from}}
  end
  def handle_call({:notify, message_set}, from, %{demand: demand} = state) when length(message_set) > demand do
    {to_dispatch, remaining} = Enum.split(message_set, demand)
    to_dispatch = Enum.map(to_dispatch, &"#{&1.value}, demand: #{demand}")
    new_state = %{state | message_set: remaining, from: from, demand: demand - length(to_dispatch)}
    {:noreply, to_dispatch, new_state}
  end
  def handle_call({:notify, message_set}, from, %{demand: demand} = state) do
    to_dispatch = Enum.map(message_set, &"#{&1.value}, demand: #{demand}")
    new_state = %{state | demand: demand - length(to_dispatch), from: from}
    {:reply, :ok, to_dispatch, new_state}
  end
  def handle_call({:notify, message_set}, _from, state) do
    {:noreply, message_set, state}
  end



  def handle_demand(demand, %{message_set: []} = state) when demand > 0 do
    {:noreply, [], %{state | demand: demand}}
  end
  def handle_demand(demand, %{message_set: message_set} = state) when demand > 0 and length(message_set) > demand do
    {to_dispatch, remaining} = Enum.split(message_set, demand)
    to_dispatch = Enum.map(to_dispatch, &"#{&1.value}, demand: #{demand}")
    {:noreply, to_dispatch, %{state | message_set: remaining, demand: 0}}
  end
  def handle_demand(demand, %{message_set: message_set} = state) when demand > 0 do
    to_dispatch = Enum.map(message_set, &"#{&1.value}, demand: #{demand}")
    new_state = %{state | message_set: [], demand: demand - length(to_dispatch)}
    GenStage.reply(state.from, :ok)
    {:noreply, to_dispatch, new_state}
  end
  def handle_demand(demand, state) do
    {:noreply, [], state}
  end
end