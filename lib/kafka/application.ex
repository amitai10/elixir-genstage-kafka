defmodule Kafka.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    consumer_group_opts = [
      # setting for the ConsumerGroup
      heartbeat_interval: 1_000,
      # this setting will be forwarded to the GenConsumer
      commit_interval: 1_000
    ]

    gen_consumer_impl = ExampleGenConsumer
    consumer_group_name = "example_group"
    topic_names = ["example_topic"]

    # List all child processes to be supervised
    children = [
      supervisor(
        KafkaEx.ConsumerGroup,
        [gen_consumer_impl, consumer_group_name, topic_names, consumer_group_opts]
      ),
      worker(GenstageExample.Producer, []),
      # worker(GenstageExample.ProducerConsumer, []),
      worker(GenstageExample.Consumer, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kafka.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
