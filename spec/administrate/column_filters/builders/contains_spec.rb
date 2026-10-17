require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Contains do
  it_behaves_like 'a column filter builder',
                  column: :title, matching: 'A Great Tech Blog', other: 'Something Else', typed: 'tech'
  it_behaves_like 'a column filter builder',
                  column: :summary, matching: 'All about Ruby gems', other: 'Cooking', typed: 'ruby'
  it_behaves_like 'a column filter builder',
                  column: :email, matching: 'ana@example.com', other: 'bo@sample.org', typed: 'EXAMPLE'
  it_behaves_like 'a column filter builder',
                  column: :url, matching: 'https://ruby-lang.org', other: 'https://python.org', typed: 'ruby'

  {
    [:views, '50'] => [1500, 20],
    [:published_at, '2026-10'] => [Time.utc(2026, 10, 17, 9), Time.utc(2025, 1, 1)],
    [:group, 'admin'] => %w[Admins Guests],
    [:title, 'a_c'] => %w[a_c abc],
    [:title, '%'] => ['100% sure', 'abc'],
    [:title, '!'] => ['wow!', 'abc']
  }.each do |(column, typed), (matching, other)|
    it "matches #{typed.inspect} against #{column}, reading the typed value literally" do
      match = Article.create!(column => matching)
      Article.create!(column => other)

      expect(filter(column, typed)).to contain_exactly(match)
    end
  end
end
