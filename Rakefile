require './hourly_seuss'

desc "Build dictionary"
task :build do
  HourlySeuss.new.build
end

desc "Tweet"
task :tweet do
  HourlySeuss.new.generate_tweet
end

task :auth do
  HourlySeuss.auth
end
