require 'dotenv/load'
require 'twitter'

$client = Twitter::REST::Client.new do |config|
	config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
	config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
	config.access_token = ENV['TWITTER_ACCESS_TOKEN_KEY']
	config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

$purge_list = []

def check(friend_id)
  puts "checking user: #{friend_id}"

  timeline = $client.user_timeline(friend_id, { :include_rts => false, :count => 1 })

  if timeline.count == 0
    purge_list << friend_id
  end

  status = $client.status(timeline[0].id)

  date = status.created_at.to_date

  now = Date.today
  thirty_days_ago = (now - 30)

  if date < thirty_days_ago
    puts "added to list: #{friend_id}"
    $purge_list << friend_id
  end
end

if ARGV.empty?
  puts "username argument is required"
  Process.exit(1)
end

username = ARGV[0]
puts "user: #{username}"

following_ids = $client.friend_ids(username)
puts "following count: #{following_ids.count}"

following_ids.each { |friend_id|
  check(friend_id)

  # NOTE: sleep is to prevent rate limit errors
  sleep(2)
}

puts "purging #{$purge_list.count} accounts"

$purge_list.each { |friend_id|
  $client.unfollow(friend_id)
  puts "unfollowed: #{friend_id}"

  # NOTE: sleep is to prevent rate limit errors
  sleep(2)
}
