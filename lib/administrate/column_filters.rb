require 'active_record'
%w[belongs_to boolean date date_time deferred email has_many has_one number polymorphic select string
   text url].each { |field| require "administrate/field/#{field}" }
require_relative 'column_filters/version'
require_relative 'column_filters/builders'
require_relative 'column_filters/config'
require_relative 'column_filters/dashboard_field'
require_relative 'column_filters/filters'

module Administrate
  module ColumnFilters
    def self.configure
      yield Config
    end

    def self.for(dashboard_class)
      Filters.new(dashboard_class).to_h
    end
  end
end
