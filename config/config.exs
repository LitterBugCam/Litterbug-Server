# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :streaming,
  ecto_repos: [Streaming.Repo]

# Configures the endpoint
config :streaming, Streaming.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("secret_key_base"),
  render_errors: [view: Streaming.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Streaming.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :streaming, Streaming.Auth.Guardian,
  issuer: "Streaming", # Name of your app/company/product
  secret_key: System.get_env("secret_key")
 
# Replace this with the output of the mix command
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
config :streaming, Streaming.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: "x.x.x"

config :aws_iot, Aws.Iot.ThingShadow.Client,
  host: "xxxxxxxxx.iot.<region>.amazonaws.com",
  port: 8883,
  client_id: "litterbugwebsite",
  ca_cert: "config/certs/VeriSign-Class 3-Public-Primary-Certification-Authority-G5.pem",
  client_cert: "config/b426e422b6-certificate.pem.crt",
  private_key: "config/certs/b426e422b6-private.pem.key",
  mqttc_opts: []

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Streaming",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: System.get_env("GUARDIAN_SECRET") || "xx...xxxx",
  serializer: Streaming.Web.GuardianSerializer

config :ex_aws,
  access_key_id: System.get_env("access_key_id"),
  secret_access_key: System.get_env("secret_access_key"),
  region: "us-west-2"

config :ex_aws, :hackney_opts,
  follow_redirect: true,
  recv_timeout: 50_000

config :ex_aws, :retries,
  max_attempts: 10,
  base_backoff_in_ms: 20,
  max_backoff_in_ms: 20_000

config :torch,
  otp_app: :streaming,
  template_format: "eex" || "slim"

config :xain, :after_callback, 
  {Phoenix.HTML, :raw}

import_config "#{Mix.env}.exs"
