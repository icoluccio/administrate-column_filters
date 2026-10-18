require 'bigdecimal'

module Administrate
  module ColumnFilters
    module Builders
      class Comparison < Ranged
        MAX_LENGTH = 40

        private

        def exact(column, _type, raw)
          number = parse(raw)
          number && column.eq(literal(number))
        end

        def compare(column, _type, operator, raw)
          number = parse(raw)
          number && column.public_send(operator, literal(number))
        end

        def range(column, _type, from, to)
          low = parse(from)
          high = parse(to)
          low && high && column.gteq(literal(low)).and(column.lteq(literal(high)))
        end

        def parse(raw)
          number = BigDecimal(raw, exception: false) if raw.length <= MAX_LENGTH
          number if number&.finite?
        end

        def literal(number)
          Arel::Nodes::Quoted.new(number)
        end
      end
    end
  end
end
