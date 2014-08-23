require './hourly_seuss'

desc "Build dictionary"
task :build do
  HourlySeuss.new.build
end

desc "Send a Tweet"
task :tweet do
  HourlySeuss.new.tweet
end

desc "Print a Tweet"
task :print do
  HourlySeuss.new.display
end

task :auth do
  HourlySeuss.auth
end
