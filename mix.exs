defmodule Streaming.Mixfile do
  use Mix.Project

  def project do
    [
      app: :streaming,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Streaming, []},
      extra_applications: [:logger,:aws_iot]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:secure_random, "~> 0.5.1"},
      {:hasher, "~> 0.1.0"},

      {:swoosh, "~> 0.8.1"},
      #{:arc, "~> 0.8.0"},
      {:porcelain, "~> 2.0"},
      {:calendar, "~> 0.17.2"},
      {:guardian, "~> 1.0-beta"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 0.12"},
      {:phoenix, "~> 1.3.0-rc"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.13"},
      {:cowboy, "~> 1.0"},
      {:poison, "~> 3.0"},
      {:httpoison, "~> 0.11.1"},
      {:ex_aws, "~> 2.0"},
  {:ex_aws_s3, "~> 2.0"},
  {:sigaws, "~> 0.7"},
  #{:hackney, "~> 1.9"},
  #{:exmqttc, "~> 0.5.0"},
   {:torch, "~> 2.0.0-rc.1"},
   {:erlport, "~> 0.9"},
{:aws, "~> 0.5.0"},
{:hexate,  ">= 0.6.0"},
#{:hulaaki, "~> 0.1.2"},
#{:mqtt, "~> 0.3.0"},
#{:gen_mqtt, "~> 0.4.0"},
{:aws_iot, git: "https://github.com/heri16/aws-iot-device-sdk-elixir.git"},
  {:sweet_xml, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
