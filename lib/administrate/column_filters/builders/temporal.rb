module Administrate
  module ColumnFilters
    module Builders
      class Temporal < Ranged
        BOUND_FOR = { gt: :last, gteq: :first, lt: :first, lteq: :last }.freeze

        private

        def exact(column, type, raw)
          bounds = day_bounds(type, raw)
          bounds && column.between(bounds.first..bounds.last)
        end

        def compare(column, type, operator, raw)
          bounds = day_bounds(type, raw)
          bounds && column.public_send(operator, bounds.public_send(BOUND_FOR.fetch(operator)))
        end

        def range(column, type, from, to)
          first = day_bounds(type, from)&.first
          last = day_bounds(type, to)&.last
          first && last && column.between(first..last)
        end

        def day_bounds(type, raw)
          day = Date.iso8601(raw)
          return [day, day] if type.type == :date

          [day.in_time_zone.beginning_of_day, day.in_time_zone.end_of_day]
        rescue Date::Error
          nil
        end
      end
    end
  end
end
