require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders do
  describe '.build' do
    let(:exact) { described_class::Exact }

    it 'builds a filter from a builder class' do
      expect(described_class.build(exact, :title)).to be_a(Proc)
    end

    it 'builds a filter from the name of a built-in builder' do
      one = Article.create!(title: 'one')
      Article.create!(title: 'two')

      expect(described_class.build(:exact, :title).call(Article.all, 'one')).to contain_exactly(one)
    end

    it 'builds a filter from a name given as a string' do
      one = Article.create!(title: 'one')
      Article.create!(title: 'two')

      expect(described_class.build('exact', :title).call(Article.all, 'one')).to contain_exactly(one)
    end

    it 'returns a lambda as it is' do
      filter = ->(scope, _value) { scope }

      expect(described_class.build(filter, :title)).to be(filter)
    end

    it 'lists the built-in names when the name is unknown' do
      expect { described_class.build(:fuzzy, :title) }
        .to raise_error(Administrate::ColumnFilters::Exceptions::UnknownBuilder, /:fuzzy.*:exact/)
    end
  end
end
