# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
config :tweetex, consumer_key: System.get_env("TWTAPI_CONSUMER_KEY")
config :tweetex, consumer_secret: System.get_env("TWTAPI_CONSUMER_SECRET")
config :tweetex, token: System.get_env("TWTAPI_ACCESS_TOKEN")
config :tweetex, token_secret: System.get_env("TWTAPI_ACCESS_TOKEN_SECRET")
config :tweetex, base_url: System.get_env("TWTAPI_BASE_URL")
config :tweetex, version: System.get_env("TWTAPI_VERSION")
config :tweetex, upload_url: System.get_env("TWTAPI_UPLOAD_URL")


if Mix.env == :test do
	config :tweetex, client: Tweetex.ClientBehaviorMock
	config :tweetex, io: Tweetex.IoBehaviorMock
else 
	config :tweetex, client: Tweetex.Client
	config :tweetex, io: Tweetex.Io
end

config :mime, :types, %{"application/vnd.api+json" => ["json-api"]}



#
# and access this configuration in your application as:
#
#     Application.get_env(:app, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
