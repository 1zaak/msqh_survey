# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :msqh_portal,
  ecto_repos: [MsqhPortal.Repo]

# Configures the endpoint
config :msqh_portal, MsqhPortal.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vAwQAmmuXrQs7iIvKwYIEpQMpoX5+10U8QTIA3GKEzb8qTr8/rBkPwCAUj+NX7pW",
  render_errors: [view: MsqhPortal.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MsqhPortal.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures liuggio/money
config :money,
  default_currency: :MYR,
  separator: ",",
  delimeter: ".",
  symbol: true,
  symbol_on_right: false,
  symbol_space: false

# Configures arc for file upload
config :arc,
  storage: Arc.Storage.Local # or Arc.Storage.Local
  #bucket: {:system, "AWS_S3_BUCKET"}, # if using Amazon S3

# Configures bamboo for email
# config :msqh_portal, MsqhPortal.Mailer,
#   adapter: Bamboo.SparkPostAdapter,
#   api_key: "20207f3bee9403a84fbc65d50168d675e431a012"

# Configures smtp for email
config :msqh_portal, MsqhPortal.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "mail.msqh.com.my",
  port: 587,
  username: "membership@msqh.com.my",
  password: "Msqh2017@",
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 100

# Configures scrivener_html
config :scrivener_html,
  routes_helper: MsqhPortal.Router.Helpers

# Configures toniq
config :toniq, redis_url: "redis://localhost:6379/0"

# Configures quantum
config :quantum, :msqh_portal,
  cron: [
    # Runs every midnight:
    "@daily": {
      ExpirationCheckerWorker, :perform
    }
  ]

config :quantum,
  timezone: "Asia/Kuala_Lumpur"

# Configures distillery
config :distillery, no_warn_missing: [:misc_random]

config :pdf_generator,
    wkhtml_path: "/usr/local/bin/wkhtmltopdf"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
