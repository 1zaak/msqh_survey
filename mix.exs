defmodule MsqhPortal.Mixfile do
  use Mix.Project

  def project do
    [app: :msqh_portal,
     version: "1.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {MsqhPortal, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :phoenix_ecto,
                    :postgrex, :comeonin, :money, :scrivener, :arc, :arc_ecto, :bamboo, :bamboo_smtp, :scrivener_ecto,
                    :scrivener_html, :timex, :timex_ecto, :toniq, :quantum, :calendar, :pdf_generator, :distillery]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.13.2"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 2.0"},
     {:money, "~> 1.2.0"},
     {:arc, "~> 0.6.0"},
     {:arc_ecto, "~> 0.5.0"},
     {:bamboo, "~> 0.7"},
     {:bamboo_smtp, "~> 1.2.1"},
     {:scrivener_ecto, "~> 1.0"},
     {:scrivener_html, "~> 1.1"},
     {:timex, "~> 3.0"},
     {:timex_ecto, "~> 3.0"},
     {:exredis, ">= 0.1.1"},
     {:toniq, "~> 1.0"},
     {:quantum, ">= 1.9.1"},
     {:calendar, "~> 0.16.1"},
     {:pdf_generator, ">=0.3.0"},
     {:distillery, "~> 1.0"},
     {:csv, "~> 1.4.2"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
