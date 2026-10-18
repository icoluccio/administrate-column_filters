require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Base do
  it 'leaves the scope alone for a blank value, without calling the subclass' do
    expect(described_class.new(:title).to_proc.call(Article.all, '')).to eq(Article.all)
  end

  it 'leaves the filtering to subclasses' do
    expect { described_class.new(:title).apply(Article.all, 'x') }.to raise_error(NotImplementedError)
  end
end
