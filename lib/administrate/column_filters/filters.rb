module Administrate
  module ColumnFilters
    class Filters
      def initialize(dashboard_class)
        @attribute_types = dashboard_class::ATTRIBUTE_TYPES
      end

      def to_h
        @attribute_types.filter_map { |name, field| filter_for(DashboardField.new(name, field)) }.to_h
      end

      private

      def filter_for(field)
        return unless field.searchable?

        builder = field.filter_override || Config.builder_for(field.field_class)
        [field.name, Builders.build(builder, field.name)] if builder
      end
    end
  end
end
