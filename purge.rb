require 'dotenv/load'
require 'twitter'

@client = Twitter::REST::Client.new do |config|
	config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
	config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
	config.access_token = ENV['TWITTER_ACCESS_TOKEN_KEY']
	config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

def check(friend_id)
  puts "checking user: #{friend_id}"

  timeline = @client.user_timeline(friend_id, { :include_rts => false, :count => 1 })

  if timeline.count == 0
    return unfollow(friend_id)
  end

  status = @client.status(timeline[0].id)

  date = status.created_at.to_date

  now = Date.today
  thirty_days_ago = (now - 30)

  if date < thirty_days_ago
    unfollow(friend_id)
  end
end

def following(username)
  @client.friend_ids(username).to_a
rescue Twitter::Error::TooManyRequests => error
  p error
  sleep error.rate_limit.reset_in
  retry
end

def unfollow(friend_id)
  @client.unfollow(friend_id)
  puts "unfollowed user: #{friend_id}"
rescue Twitter::Error::TooManyRequests => error
  p error
  sleep error.rate_limit.reset_in
  retry
end

if ARGV.empty?
  puts "username argument is required"
  Process.exit(1)
end

username = ARGV[0]
puts "Twitter account: #{username}"

filename = "#{username}.cache"
f = open(filename, "a")

checked_list = []
if File.exists?(filename)
  checked_list = File.readlines(filename)
end

following_ids = following(username)
puts "following count: #{following_ids.count}"

following_ids.each do |friend_id|
  skip = false
  checked_list.each do |line|
    if line.strip.include? friend_id.to_s
      skip = true
      puts "skipping check: #{friend_id}"
      next
    end
  end

  if skip
    next
  end

  check(friend_id)

  f << "#{friend_id}\n"
end

puts "done"
