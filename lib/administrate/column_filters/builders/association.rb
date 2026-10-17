module Administrate
  module ColumnFilters
    module Builders
      class Association < Associated
        def apply(scope, value)
          key = scope.klass.primary_key
          scope.where(key => with_related(scope, value).select(key))
        end

        private

        def with_related(scope, value)
          related = reflection(scope).klass
          scope.klass.unscoped.joins(name).where(related.table_name => { related.primary_key => value })
        end
      end
    end
  end
end
