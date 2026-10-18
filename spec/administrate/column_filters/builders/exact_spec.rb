require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Exact do
  it_behaves_like 'a column filter builder', column: :views, matching: 3, other: 30, typed: '3'
  it_behaves_like 'a column filter builder', column: :status, matching: 'draft', other: 'published', typed: 'draft'

  it 'matches nothing for a name the enum column does not know, not the rows with no value' do
    Article.create!(status: nil)
    Article.create!(status: 'draft')

    expect(described_class.new(:status).to_proc.call(Article.all, 'bogus')).to be_empty
  end
end
