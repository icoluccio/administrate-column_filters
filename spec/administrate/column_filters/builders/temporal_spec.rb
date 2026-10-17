require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Temporal do
  {
    [:published_at, '2026-10-17'] => %i[midday], [:published_at, '>2026-10-17'] => %i[next_day],
    [:published_at, '>=2026-10-17'] => %i[midday next_day], [:published_at, '<2026-10-17'] => %i[late_night],
    [:published_at, '<=2026-10-17'] => %i[late_night midday],
    [:published_at, '2026-10-16..2026-10-17'] => %i[late_night midday],
    [:released_on, '2026-10-17'] => %i[seventeenth], [:released_on, '>2026-10-15'] => %i[seventeenth],
    [:released_on, '2026-10-01..2026-10-16'] => %i[fifteenth],
    [:published_at, 'nonsense'] => [], [:published_at, '>nonsense'] => [], [:published_at, '2026-13-45'] => [],
    [:published_at, '2026-10-17..'] => [], [:published_at, '..2026-10-17'] => [], [:published_at, 'a..b'] => []
  }.each do |(column, typed), names|
    it "answers #{column}:#{typed} with #{names.inspect}" do
      rows = publication_dates

      expect(filter(column, typed)).to match_array(names.map { |name| rows[name] })
    end
  end
end
