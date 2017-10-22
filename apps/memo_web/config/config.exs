# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :memo_web,
  namespace: MemoWeb
#   ecto_repos: [MemoWeb.Repo]

# Configures the endpoint
config :memo_web, MemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ke/aiynlp+zJ62EoNPbBEj4qVUkzg1Xzn9stvhf0Aim9JlKJw1Z689YbvXKx5nGr",
  render_errors: [view: MemoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MemoWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :memo_web, :generators,
  context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
