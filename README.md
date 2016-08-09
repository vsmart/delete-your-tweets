# DeleteYourTweets [![Build Status](https://travis-ci.org/vsmart/delete-your-tweets.svg?branch=travis)](https://travis-ci.org/vsmart/delete-your-tweets)

This app lets you bulk delete your tweets.

## Setup

###
* Run `make install`. If it fails, it's likely you don't have some of the dependencies for Phoenix apps installed. Go to the [Phoenix Installation Guide](http://www.phoenixframework.org/docs/installation) for help.
* Next, you need to register a Twitter app. To do that, go to [Twitter Apps](https://apps.twitter.com).
* You will receive a key and a secret for your app. Expose these in your environment as `TWITTER_CONSUMER_KEY` and `TWITTER_CONSUMER_SECRET`, e.g. `export TWITTER_CONSUMER_KEY=ohai`.

## Run the app

* Run `make start`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more about Phoenix

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
