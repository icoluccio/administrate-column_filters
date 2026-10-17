module Administrate
  module ColumnFilters
    module Builders
      class Associated < Base
        private

        def reflection(scope)
          scope.klass.reflect_on_association(name) || raise(Exceptions::UnknownAssociation.new(name, scope.klass))
        end
      end
    end
  end
end
