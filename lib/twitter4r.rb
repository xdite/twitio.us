require('rubygems')
gem('twitter4r', '0.3.0')
require('twitter')
require 'twitter/console'
require 'twitter/rails' 
module TwitterObj
  ClientContext = Twitter::Client.from_config("#{RAILS_ROOT}/config/twitter.yml", ENV["RAILS_ENV"])
end

