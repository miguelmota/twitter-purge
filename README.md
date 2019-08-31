# twitter-purge

> Unfollows a list of accounts you're following that haven't tweeted in over 30 days.

## Getting started

Make sure to have [ruby](https://www.ruby-lang.org/en/) installed (you can use [rvm](https://rvm.io/)), and then install dependencies with [bundler](https://bundler.io/):

```bash
bundle install
```

Set the required environment variables in `.env` containing your twitter API credentials:

- `TWITTER_CONSUMER_KEY`
- `TWITTER_CONSUMER_SECRET`
- `TWITTER_ACCESS_TOKEN_KEY`
- `TWITTER_ACCESS_TOKEN_SECRET`

You can use the sample env file for reference:

```bash
mv .env.sample .env
```

You can get Twitter API credentials from the Twitter [apps page](https://developer.twitter.com/en/apps).

Run the script passing your username:

```bash
$ ruby purge.rb @username

Twitter account: @miguelmota
following count: 4154
checking user: 45409867
checking user: 133008925
checking user: 26318018
...
```

## License

[MIT](LICENSE)
