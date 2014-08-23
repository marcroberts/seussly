require 'rubygems'
require 'bundler'

Bundler.require
Dotenv.load

class HourlySeuss

  def initialize
    @markov = MarkyMarkov::Dictionary.new('seuss')

    @twitter = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_API_KEY']
      config.consumer_secret = ENV['TWITTER_API_SECRET']
      config.access_token = ENV['TWITTER_OAUTH_TOKEN']
      config.access_token_secret = ENV['TWITTER_OAUTH_SECRET']
    end
  end

  def build
    PersistentDictionary.delete_dictionary! @markov
    @markov = MarkyMarkov::Dictionary.new('seuss')
    Dir.glob('corpus/*.txt').each do |file|
      @markov.parse_file file
    end
    @markov.save_dictionary!
  end

  def generate_tweet
    tweet = ''
    attempt = 1

    while attempt <= 3
      sentence = @markov.generate_n_sentences(1).strip
      if tweet.size + 1 + sentence.size <= 140
        tweet += " #{sentence}"
        attempt = 1
      else
        attempt += 1
      end
    end
    @twitter.update tweet
  end

  def self.auth
    consumer = OAuth::Consumer.new(ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'], :site => "https://api.twitter.com" )
    request_token = consumer.get_request_token

    puts "Visit: #{request_token.authorize_url} to authorise the app\n"
    puts "Enter the pin code"
    pin = STDIN.gets.chomp

    access_token = request_token.get_access_token :oauth_verifier => pin

    puts "Token: #{access_token.token}, Secret: #{access_token.secret}\n\n"
  end

end
