module Administrate
  module ColumnFilters
    module Builders
      class Boolean < Base
        TRUE_TEXTS = %w[true t 1 yes y on].freeze
        FALSE_TEXTS = %w[false f 0 no n off].freeze

        def apply(scope, value)
          parsed = parse(value.to_s.strip.downcase)
          parsed.nil? ? scope.none : scope.where(name => parsed)
        end

        private

        def parse(text)
          return true if TRUE_TEXTS.include?(text)

          false if FALSE_TEXTS.include?(text)
        end
      end
    end
  end
end
