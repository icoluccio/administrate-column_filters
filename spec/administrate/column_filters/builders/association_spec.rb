require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Association do
  it 'matches the rows that have a related record with the typed id' do
    commented = Article.create!
    other = Article.create!
    comment = Comment.create!(article: commented, body: 'First')
    Comment.create!(article: other, body: 'Second')

    expect(described_class.new(:comments).to_proc.call(Article.all, comment.id.to_s)).to contain_exactly(commented)
  end

  it_behaves_like 'an association builder', missing: :reviews

  it 'lists a row once when several related records match' do
    article = Article.create!
    ids = Array.new(2) { Comment.create!(article: article, body: 'x').id }

    expect(described_class.new(:comments).to_proc.call(Article.all, ids.first.to_s).to_a).to eq([article])
  end
end
