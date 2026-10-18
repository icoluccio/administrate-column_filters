module Administrate
  module ColumnFilters
    module Builders
      class Contains < Base
        ESCAPE = '!'.freeze
        TEXT_TYPES = %i[string text].freeze
        CAST_TARGET = Arel.sql('CHAR(256)')

        def apply(scope, value)
          pattern = "%#{scope.klass.sanitize_sql_like(value.to_s, ESCAPE)}%"
          scope.where(searchable(scope).matches(pattern, ESCAPE))
        end

        private

        def searchable(scope)
          column = scope.arel_table[name]
          return column if TEXT_TYPES.include?(scope.klass.type_for_attribute(name.to_s).type)

          Arel::Nodes::NamedFunction.new('CAST', [column.as(CAST_TARGET)])
        end
      end
    end
  end
end
