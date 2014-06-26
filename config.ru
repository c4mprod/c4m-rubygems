require 'bundler/setup'
require 'geminabox'
require 'rack-ssl-enforcer'

RACK_ENV = ENV['RACK_ENV'] || 'development'
ROOT = File.expand_path(File.dirname(__FILE__))

warn("Warning: 'GEM_SERVER_USERNAME' env is not set") unless ENV['GEM_SERVER_USERNAME']
warn("Warning: 'GEM_SERVER_PASSWORD' env is not set") unless ENV['GEM_SERVER_PASSWORD']

# Disable RubyGems supports generating indexes for the so called legacy versions (< 1.2)
Geminabox.build_legacy = false
Geminabox.data = File.join(ROOT, "repository")

use Rack::CommonLogger

unless RACK_ENV == 'development'
  use Rack::SslEnforcer
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    ENV['GEM_SERVER_USERNAME'] && ENV['GEM_SERVER_PASSWORD'] &&
        username == ENV['GEM_SERVER_USERNAME'] && password == ENV['GEM_SERVER_PASSWORD']
  end
end

run Geminabox::Server
