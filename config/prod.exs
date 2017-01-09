use Mix.Config

config :delete_your_tweets, DeleteYourTweets.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "delete-your-tweets.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json"
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info
     config :delete_your_tweets, DeleteYourTweets.Endpoint, root: "."
