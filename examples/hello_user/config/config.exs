# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :hello_user, HelloUser.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "LhQGXEISk9W1S5pJk7QgmGySTxMMWTuIxpek5NocU6KO6FiHu1RTBCM8YZRg5Yzz",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: HelloUser.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :swaggerdoc,
  swagger_version: "2.0",
  project_version: "1.0.0",
  project_name: "Hello User",
  project_desc: "The REST API for the Hello User",
  project_terms: "https://www.mozilla.org/en-US/MPL/2.0/",
  project_contact_name: "OpenAperture",
  project_contact_email: "openaperture@lexmark.com",
  project_contact_url: "http://openaperture.io",
  project_license_name: "Mozilla Public License, v. 2.0",
  project_license_url: "https://www.mozilla.org/en-US/MPL/2.0/",
  host: "openaperture.io",
  base_path: "/",
  schemes: ["https"],
  consumes: ["application/json"],
  produces: ["application/json"]  

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
