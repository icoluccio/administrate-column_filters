Administrate::ColumnFilters
===========================

[![CI](https://github.com/icoluccio/administrate-column_filters/actions/workflows/ci.yml/badge.svg)](https://github.com/icoluccio/administrate-column_filters/actions/workflows/ci.yml)

# Table of contents
  - [Description](#description)
  - [Why use it](#why-use-it)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Basic usage](#basic-usage)
    - [Which columns get a filter](#which-columns-get-a-filter)
    - [Comparisons and ranges](#comparisons-and-ranges)
    - [Associations](#associations)
    - [Overriding a filter](#overriding-a-filter)
    - [Custom field types](#custom-field-types)
    - [Limits](#limits)
  - [Contributing](#contributing)
  - [Releases](#releases)
  - [About](#about)
  - [License](#license)

-----------------------

## Description

Administrate reads `column:value` tokens from the index search bar, but each token needs a hand-written lambda in the dashboard's `COLLECTION_FILTERS`. Administrate::ColumnFilters builds those lambdas from the dashboard's `ATTRIBUTE_TYPES`.

## Why use it

Without the gem, filtering one column from the search bar means one hand-written lambda per column, on each dashboard:

```ruby
COLLECTION_FILTERS = {
  title: ->(rows, value) { rows.where('title ILIKE ?', "%#{value}%") },
  views: ->(rows, value) { rows.where(views: value) },
  published: ->(rows, value) { rows.where(published: ActiveModel::Type::Boolean.new.cast(value)) }
}.freeze
```

With the gem, the same dashboard takes one line, and a column added later gets its filter without more code:

```ruby
COLLECTION_FILTERS = Administrate::ColumnFilters.for(self).freeze
```

The gem gives you:

- **Defaults per field type.** Text, select, boolean, number, date and association columns each get a matcher suited to their type, and dashboards share the same rules.
- **More than substring matching.** Number and date columns take `>`, `<` and `a..b`, a bare date matches that whole day, and associations match by id.
- **Overrides at three levels.** Replace one column with a merge, one field with the `filter` option, or a whole field type with `configure`.
- **Specs.** The filters run through Administrate's own search and a real request, on Rails 7.1 to 8.1.

Skip the gem when:

- A dashboard needs one or two filters. Two lambdas are shorter than a dependency.
- You want a form with dropdowns and date pickers. This gem extends the search bar, and a form needs a different tool.
- You need times of day, or association matching by name. See [Limits](#limits).

## Installation
The gem is private. Add the following line to your application's Gemfile, pinned to a tag:

```ruby
gem 'administrate-column_filters', git: 'https://github.com/icoluccio/administrate-column_filters', tag: 'v0.1.0'
```

And then execute:
```bash
$ bundle
```

It supports Administrate 1.x on Ruby 3.3 and up, with Rails 7.1 to 8.1.

## Usage

### Basic usage
Assign the result to `COLLECTION_FILTERS` in a dashboard:

```ruby
class ArticleDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    title: Field::String,
    views: Field::Number.with_options(searchable: true),
    published: Field::Boolean.with_options(searchable: true)
  }.freeze

  COLLECTION_FILTERS = Administrate::ColumnFilters.for(self).freeze
end
```

`ATTRIBUTE_TYPES` must be defined above this line, or on a parent dashboard: `for` runs while the class body loads, and reads that constant to build the filters.

The search bar now accepts `title:tech`, `views:3` and `published:false`. Several tokens combine, so `title:tech published:true` returns the rows that satisfy both. `for` returns a plain hash, so your own filters merge on top:

```ruby
COLLECTION_FILTERS = Administrate::ColumnFilters.for(self).merge(
  drafts: ->(articles) { articles.where(published: false) }
).freeze
```

### Which columns get a filter
A column gets a filter when its field is searchable and its type has a builder:

| Field                                                        | `column:value` returns the rows where                        |
|--------------------------------------------------------------|--------------------------------------------------------------|
| `Field::String`, `Field::Text`, `Field::Email`, `Field::Url` | the column contains the value, ignoring case                 |
| `Field::Select`                                              | the column equals the value                                  |
| `Field::Boolean`                                             | the column equals the value, cast like ActiveModel casts it  |
| `Field::Number`                                              | the column equals the value; accepts comparisons and ranges  |
| `Field::Date`, `Field::DateTime`                             | the column falls on that day; accepts comparisons and ranges |
| `Field::BelongsTo`                                           | the foreign key equals the value                             |
| `Field::HasOne`, `Field::HasMany`                            | a related record has that id                                 |

`Field::String`, `Field::Email`, `Field::Url` and `Field::Select` are searchable by default. Set `searchable: true` on the other types, or `searchable: false` to leave a field out.

Text matching goes through Arel's `matches`: `ILIKE` on PostgreSQL, `LIKE` elsewhere. The characters `%`, `_` and `!` in the typed value match themselves. A column that is not text, such as a number, a uuid or a timestamp, is cast to text first, so `created_at:2026-10` matches the timestamp's text form.

A boolean column accepts `true`, `t`, `1`, `yes`, `y` and `on`, or `false`, `f`, `0`, `no`, `n` and `off`, in any case. Any other word matches nothing. A column name with no value, such as `status:`, does nothing.

### Comparisons and ranges
Number, Date and DateTime columns take an operator or a range:

| You type                                   | It returns the rows where                          |
|--------------------------------------------|----------------------------------------------------|
| `views:10`                                 | `views` equals 10                                  |
| `views:>10`, `views:>=10`                  | `views` is above, or at least, 10                  |
| `views:<10`, `views:<=10`                  | `views` is below, or at most, 10                   |
| `views:5..10`                              | `views` is between 5 and 10, both included         |
| `published_at:2026-10-17`                  | `published_at` falls on that day                   |
| `published_at:>2026-10-17`                 | `published_at` is after the end of that day        |
| `published_at:2026-10-01..2026-10-31`      | `published_at` falls from the first day to the last |

Numbers compare as numbers, so `views:<5.7` includes 5 and `views:5.7` matches no integer. A value that does not parse matches nothing: `views:abc` and `views:0x1A` return no rows. Dates use the ISO format `YYYY-MM-DD` and the application's time zone.

### Associations
Associations filter by id. `author:12` returns the articles whose `author_id` is 12, and `comments:5` returns the articles that have a comment with id 5. Declare the field as searchable, and give Administrate the columns its own text search needs:

```ruby
author: Field::BelongsTo.with_options(searchable: true, searchable_fields: %w[name])
```

`Field::Polymorphic` gets no filter, because an id alone does not say which table it points to.

### Overriding a filter
Three levels, from narrow to wide.

A merge replaces one column on one dashboard:

```ruby
COLLECTION_FILTERS = Administrate::ColumnFilters.for(self).merge(
  title: ->(articles, value) { articles.where(title: value) }
).freeze
```

The `filter` option replaces the matcher for one field. It takes the name of a built-in builder (`:boolean`, `:exact`, `:contains`, `:comparison`, `:temporal`, `:foreign_key`, `:association`), a builder class, or a lambda that takes the scope and the typed value:

```ruby
title: Field::String.with_options(filter: :exact)
slug: Field::String.with_options(filter: MyApp::SlugBuilder)
```

A builder class subclasses `Administrate::ColumnFilters::Builders::Base` and implements `apply(scope, value)`. It receives the column name in `name`.

### Custom field types
Register a builder for a field class of your own with `configure`. The registry picks the builder of the nearest ancestor, so a subclass of `Field::String` keeps `Contains` unless you register another:

```ruby
# config/initializers/administrate_column_filters.rb
Administrate::ColumnFilters.configure do |config|
  config.register(Field::Money, Administrate::ColumnFilters::Builders::Comparison)
end
```

### Limits
These field types get no filter: `Time`, `Password`, `RichText` and `Polymorphic`.

Administrate splits the search term on spaces and colons, so a value cannot contain either. Times of day contain a colon, so `Time` has no filter and `DateTime` matches whole days. Values with spaces do not work.

## Contributing

1. Fork it
2. Run `bundle install && bundle exec appraisal generate` once, to install dependencies and generate the per-Rails-version gemfiles (`gemfiles/rails_*.gemfile`) used for testing
3. Run `bundle exec overcommit --install` once, to enable the pre-push hook. Before each push it runs `rake ci`: RuboCop, bundler-audit, flay and RSpec with a 100% line and branch coverage gate
4. Create your feature branch (`git checkout -b my-new-feature`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Run the gate (`bundle exec rake ci`)
7. Run the specs against one Rails version (`BUNDLE_GEMFILE=gemfiles/rails_7.1.gemfile bundle exec rspec`)
8. Push your branch (`git push origin my-new-feature`)
9. Create a new Pull Request to `main` branch

## Releases
[See what's changed in a recent version](https://github.com/icoluccio/administrate-column_filters/releases)

## About

The maintainer of this gem is:
* [Ignacio Coluccio](https://github.com/icoluccio)

## License

**administrate-column_filters** is available under the MIT [license](LICENSE.md).

    Copyright (c) 2026 Ignacio Coluccio
