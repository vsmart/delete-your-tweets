defmodule DeleteYourTweets do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    configure_twitter_client

    children = [
      # Start the endpoint when the application starts
      supervisor(DeleteYourTweets.Endpoint, []),
      # Start the Ecto repository
      supervisor(DeleteYourTweets.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(DeleteYourTweets.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DeleteYourTweets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DeleteYourTweets.Endpoint.config_change(changed, removed)
    :ok
  end

  def configure_twitter_client do
    consumer_key = System.get_env("TWITTER_CONSUMER_KEY")
    consumer_secret = System.get_env("TWITTER_CONSUMER_SECRET")

    if !consumer_key || !consumer_secret do
      raise "Please set TWITTER_CONSUMER_KEY and TWITTER_CONSUMER_SECRET"
    end

    ExTwitter.configure(
      consumer_key: consumer_key,
      consumer_secret: consumer_secret)
  end
end
