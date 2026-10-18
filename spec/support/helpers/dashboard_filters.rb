module DashboardFilters
  def filters_for(attribute_types)
    described_class.new(Class.new { const_set(:ATTRIBUTE_TYPES, attribute_types) }).to_h
  end

  def searchable(field_class)
    field_class.with_options(searchable: true)
  end

  def filter_option(value)
    Administrate::Field::String.with_options(filter: value)
  end

  def unrecognized_field
    Class.new(Administrate::Field::Base) { def self.searchable? = true }
  end

  def config_mappings
    {
      Administrate::Field::Email => Administrate::ColumnFilters::Builders::Contains,
      Administrate::Field::Number => Administrate::ColumnFilters::Builders::Comparison,
      Administrate::Field::HasMany => Administrate::ColumnFilters::Builders::Association,
      Administrate::Field::Polymorphic => nil
    }
  end
end
