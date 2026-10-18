module Administrate
  module ColumnFilters
    module Builders
      class ForeignKey < Associated
        def apply(scope, value)
          scope.where(reflection(scope).foreign_key => value)
        end
      end
    end
  end
end
