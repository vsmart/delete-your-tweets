defmodule DeleteYourTweets.Repo.Migrations.CreateTweetDeletion do
  use Ecto.Migration

  def change do
    create table(:tweet_deletions) do
      add :type, :string
      add :created_at, :datetime

      timestamps
    end

  end
end
