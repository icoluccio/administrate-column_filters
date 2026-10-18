require_relative 'boot'

require 'rails/all'
require 'administrate'

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.secret_key_base = 'dummy-secret'
    config.hosts.clear
  end
end
