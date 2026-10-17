require 'administrate/base_dashboard'

class ArticleDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    title: Field::String,
    summary: Field::Text,
    views: Field::Number.with_options(searchable: true),
    published: Field::Boolean.with_options(searchable: true),
    group: Field::String.with_options(searchable: false),
    email: Field::Email,
    url: Field::Url,
    status: Field::Select.with_options(collection: %w[draft published]),
    published_at: Field::DateTime.with_options(searchable: true),
    released_on: Field::Date.with_options(searchable: true),
    author: Field::BelongsTo.with_options(searchable: true, searchable_fields: %w[name]),
    comments: Field::HasMany.with_options(searchable: true, searchable_fields: %w[body])
  }.freeze

  COLLECTION_ATTRIBUTES = %i[id title views published].freeze
  SHOW_PAGE_ATTRIBUTES = %i[id title summary views published group email url status].freeze
  FORM_ATTRIBUTES = %i[title summary views published group email url status].freeze

  COLLECTION_FILTERS = Administrate::ColumnFilters.for(self).merge(
    drafts: ->(articles) { articles.where(published: false) }
  ).freeze
end
