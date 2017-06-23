use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :smart_site, SmartSite.Web.Endpoint,
  secret_key_base: "iU0fu4ea0oNSlf1OuXhtQpRn3k3xx5duK8ejunCFyFj4PxPGRu/nyCSzmTdL0em/"

# Configure your database
config :smart_site, SmartSite.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "smart_site_prod",
  pool_size: 15
