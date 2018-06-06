defmodule ExampleGenConsumer do
  use KafkaEx.GenConsumer

  alias KafkaEx.Protocol.Fetch.Message

  require Logger

  # note - messages are delivered in batches
  def handle_message_set(message_set, state) do
    Logger.debug "000000000000000000"
    
    GenstageExample.Producer.notify(message_set)
    {:async_commit, state}
  end
end