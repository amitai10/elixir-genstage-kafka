defmodule KafkaTest do
  use ExUnit.Case
  doctest Kafka

  test "greets the world" do
    assert Kafka.hello() == :world
  end
end
