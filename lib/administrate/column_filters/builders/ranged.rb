module Administrate
  module ColumnFilters
    module Builders
      class Ranged < Base
        OPERATORS = { '>=' => :gteq, '<=' => :lteq, '>' => :gt, '<' => :lt }.freeze
        RANGE_SEPARATOR = '..'.freeze

        def apply(scope, value)
          column = scope.arel_table[name]
          predicate = predicate_for(column, scope.klass.type_for_attribute(name.to_s), value.to_s)
          predicate ? scope.where(predicate) : scope.none
        end

        private

        def predicate_for(column, type, text)
          return range(column, type, *text.split(RANGE_SEPARATOR, 2)) if text.include?(RANGE_SEPARATOR)

          operator, operand = split_operator(text)
          operator ? compare(column, type, operator, operand) : exact(column, type, operand)
        end

        def split_operator(text)
          prefix = OPERATORS.keys.find { |symbol| text.start_with?(symbol) }
          prefix ? [OPERATORS[prefix], text.delete_prefix(prefix)] : [nil, text]
        end

        %i[exact compare range].each do |method|
          define_method(method) { |*| raise NotImplementedError }
        end
      end
    end
  end
end
