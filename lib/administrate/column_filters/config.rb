module Administrate
  module ColumnFilters
    class Config
      DEFAULT_BUILDERS = {
        Administrate::Field::Boolean => Builders::Boolean,
        Administrate::Field::Number => Builders::Comparison,
        Administrate::Field::Select => Builders::Exact,
        Administrate::Field::String => Builders::Contains,
        Administrate::Field::Text => Builders::Contains,
        Administrate::Field::Email => Builders::Contains,
        Administrate::Field::Url => Builders::Contains,
        Administrate::Field::Date => Builders::Temporal,
        Administrate::Field::DateTime => Builders::Temporal,
        Administrate::Field::BelongsTo => Builders::ForeignKey,
        Administrate::Field::Polymorphic => nil,
        Administrate::Field::HasOne => Builders::Association,
        Administrate::Field::HasMany => Builders::Association
      }.freeze

      class << self
        def register(field_class, builder)
          builders[field_class] = builder
        end

        def builder_for(field_class)
          builders[nearest_ancestor(field_class)]
        end

        def reset!
          @builders = nil
        end

        private

        def builders
          @builders ||= DEFAULT_BUILDERS.dup
        end

        def nearest_ancestor(field_class)
          candidates = builders.keys.select { |klass| field_class <= klass }
          candidates.min_by { |klass| field_class.ancestors.index(klass) }
        end
      end
    end
  end
end
