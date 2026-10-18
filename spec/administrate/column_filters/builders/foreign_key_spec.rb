require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::ForeignKey do
  it_behaves_like 'an association builder', missing: :writer

  it 'matches the rows that belong to the record with the typed id' do
    ana = Author.create!(name: 'Ana')
    mine = Article.create!(author: ana)
    Article.create!(author: Author.create!(name: 'Bo'))

    expect(described_class.new(:author).to_proc.call(Article.all, ana.id.to_s)).to contain_exactly(mine)
  end
end
