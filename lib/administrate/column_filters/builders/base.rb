module Administrate
  module ColumnFilters
    module Builders
      class Base
        def initialize(name)
          @name = name
        end

        def to_proc
          ->(scope, value) { value.to_s.strip.empty? ? scope : apply(scope, value) }
        end

        def apply(_scope, _value)
          raise NotImplementedError
        end

        private

        attr_reader :name
      end
    end
  end
end
