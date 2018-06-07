defmodule Kafka.MixProject do
  use Mix.Project

  def project do
    [
      app: :kafka,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :kafka_ex],
      mod: {Kafka.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:gen_stage, "~> 0.11"},
      {:kafka_ex, "~> 0.8.3"},
      {:poison, "~> 3.1"},
      # {:snappy, git: "https://github.com/fdmanana/snappy-erlang-nif"}
    ]
  end
end


