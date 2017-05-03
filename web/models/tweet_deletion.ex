defmodule DeleteYourTweets.TweetDeletion do
  use DeleteYourTweets.Web, :model

  schema "tweet_deletions" do
    field :type, :string
    field :created_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(type created_at)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
