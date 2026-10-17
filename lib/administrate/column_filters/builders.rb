require_relative 'exceptions/unknown_builder'
require_relative 'exceptions/unknown_association'
require_relative 'builders/base'
require_relative 'builders/boolean'
require_relative 'builders/exact'
require_relative 'builders/contains'
require_relative 'builders/ranged'
require_relative 'builders/comparison'
require_relative 'builders/temporal'
require_relative 'builders/associated'
require_relative 'builders/foreign_key'
require_relative 'builders/association'

module Administrate
  module ColumnFilters
    module Builders
      NAMED = {
        boolean: Boolean, exact: Exact, contains: Contains, comparison: Comparison,
        temporal: Temporal, foreign_key: ForeignKey, association: Association
      }.freeze

      def self.build(spec, name)
        return spec if spec.is_a?(Proc)

        resolve(spec).new(name).to_proc
      end

      def self.resolve(spec)
        return spec unless spec.is_a?(Symbol) || spec.is_a?(String)

        NAMED.fetch(spec.to_sym) { raise Exceptions::UnknownBuilder.new(spec, NAMED.keys) }
      end
    end
  end
end
