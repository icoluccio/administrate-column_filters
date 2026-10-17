module Administrate
  module ColumnFilters
    class DashboardField
      def initialize(name, field)
        @name = name
        @field = field
      end

      attr_reader :name

      delegate :searchable?, to: :field

      def filter_override
        options[:filter]
      end

      def field_class
        deferred? ? field.deferred_class : field
      end

      private

      attr_reader :field

      def options
        deferred? ? field.options : {}
      end

      def deferred?
        field.respond_to?(:deferred_class)
      end
    end
  end
end
