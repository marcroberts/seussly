require 'rubygems'
require 'bundler'

Bundler.require

class HourlySeuss

  def initialize
    @markov = MarkyMarkov::Dictionary.new('seuss')
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
    puts tweet.strip
  end

end
