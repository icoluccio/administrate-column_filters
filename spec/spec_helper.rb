ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100
  skip '/spec/'
end

require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rack/test'
Dir[File.join(__dir__, 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Schema.verbose = false
load File.expand_path('dummy/db/schema.rb', __dir__)

RSpec.configure do |config|
  config.extend DashboardFilters

  config.include AdministrateSearch
  config.include BuilderFilter
  config.include BuilderFixtures
  config.include DashboardFilters

  config.expect_with(:rspec) { |expectations| expectations.syntax = :expect }

  config.around do |example|
    Article.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
