# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :smart_site,
  ecto_repos: [SmartSite.Repo]

# Configures the endpoint
config :smart_site, SmartSite.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6ajCscUj32fhYjl169qw/ctPZ5irUDrPeWIXNe79nBTOsq5BQvuM5kU6LEsTLK5C",
  render_errors: [view: SmartSite.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: SmartSite.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Uberauth Guardian
key = %{

}
config :guardian, Guardian,
  hooks: GuardianDb,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "SmartSite",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "DP+EUUp5tFfk9JTDsS8folmVNp5ltLJfr0MQJRiQvryoNabmUiKDAnIWFGpSywvC",
  serializer: SmartSite.GuardianSerializer

# Uberauth Guardian_DB
config :guardian_db, GuardianDb,
  repo: SmartSite.Repo,
  schema_name: "guardian_tokens"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
