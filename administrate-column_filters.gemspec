lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'administrate/column_filters/version'

Gem::Specification.new do |s|
  s.name        = 'administrate-column_filters'
  s.version     = Administrate::ColumnFilters::VERSION
  s.authors     = ['Ignacio Coluccio']
  s.email       = ['ignacio.coluccio@gmail.com']
  s.homepage    = 'https://github.com/icoluccio/administrate-column_filters'
  s.summary     = 'Typed column:value filters for the Administrate search bar'
  s.description = 'Builds a dashboard\'s COLLECTION_FILTERS from its ATTRIBUTE_TYPES: substring and exact ' \
                  'matching for text columns, comparisons and ranges for numbers and dates, and association ' \
                  'ids, instead of one hand-written lambda per column.'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.3'
  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = s.homepage
  s.metadata['changelog_uri'] = "#{s.homepage}/blob/main/CHANGELOG.md"
  s.metadata['bug_tracker_uri'] = "#{s.homepage}/issues"
  s.metadata['rubygems_mfa_required'] = 'true'

  s.files = Dir['lib/**/*.rb'] + %w[README.md LICENSE.md CHANGELOG.md]

  s.add_dependency 'activerecord', '>= 7.1', '< 9'
  s.add_dependency 'administrate', '>= 1.0', '< 2'
  s.add_dependency 'bigdecimal', '>= 3.1'
end
