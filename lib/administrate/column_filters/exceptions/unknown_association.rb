module Administrate
  module ColumnFilters
    module Exceptions
      class UnknownAssociation < ArgumentError
        def initialize(name, model)
          super("#{model.name} has no association #{name.inspect}, so that field cannot be filtered")
        end
      end
    end
  end
end
