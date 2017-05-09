defmodule DeleteYourTweets.TweetDeletionTest do
  use DeleteYourTweets.ModelCase

  alias DeleteYourTweets.TweetDeletion

  @valid_attrs %{created_at: "2010-04-17 14:00:00", type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TweetDeletion.changeset(%TweetDeletion{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TweetDeletion.changeset(%TweetDeletion{}, @invalid_attrs)
    refute changeset.valid?
  end
end
