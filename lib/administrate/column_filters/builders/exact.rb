module Administrate
  module ColumnFilters
    module Builders
      class Exact < Base
        def apply(scope, value)
          typed = typed_value(scope, value)
          typed.nil? ? scope.none : scope.where(name => typed)
        end

        private

        def typed_value(scope, value)
          scope.klass.type_for_attribute(name.to_s).serialize(value)
        end
      end
    end
  end
end
