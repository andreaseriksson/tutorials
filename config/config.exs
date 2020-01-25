# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tutorial,
  ecto_repos: [Tutorial.Repo]

# Configures the endpoint
config :tutorial, TutorialWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IgK/07WPhpZdY3pPfPkF1FhjTlAt1hCWCAYgG3nKsNbD89i6Z/lh/Hb1e0XX4W6U",
  render_errors: [view: TutorialWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tutorial.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "ne2OraWqFq6nPInMelyiZPZDgIIQmtRN"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tutorial, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: TutorialWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: TutorialWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

config :phoenix_swagger, json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
