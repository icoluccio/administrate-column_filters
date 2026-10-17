module Administrate
  module ColumnFilters
    module Exceptions
      class UnknownBuilder < ArgumentError
        def initialize(name, known)
          super("Unknown column filter #{name.inspect}. Use one of #{known.map(&:inspect).join(', ')}.")
        end
      end
    end
  end
end
