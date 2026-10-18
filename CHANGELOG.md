## Change log

### V0.1.1
* [#3](https://github.com/icoluccio/administrate-column_filters/pull/3) Publish the gem to RubyGems: install it with `gem 'administrate-column_filters'`, with no git source or token needed. - [@icoluccio](https://github.com/icoluccio/administrate-column_filters/pull/3).
* [#2](https://github.com/icoluccio/administrate-column_filters/pull/2) Fix `views:1e999999` raising `PG::NumericValueOutOfRange` on Postgres: a number too large for the database now matches nothing. Run the suite against Postgres in CI, and document testing a dashboard in the README. - [@icoluccio](https://github.com/icoluccio/administrate-column_filters/pull/2).

### V0.1.0
* [#1](https://github.com/icoluccio/administrate-column_filters/pull/1) Add `Administrate::ColumnFilters.for`, which builds search-bar filters from `ATTRIBUTE_TYPES`, with comparisons and ranges, association filters, a `filter` field option and a `configure` registry - [@icoluccio](https://github.com/icoluccio).
