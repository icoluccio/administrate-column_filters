require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Filters do
  {
    { title: searchable(Administrate::Field::String), summary: searchable(Administrate::Field::Text),
      views: searchable(Administrate::Field::Number), published: searchable(Administrate::Field::Boolean) } =>
      %i[title summary views published],
    { title: Administrate::Field::String, email: Administrate::Field::Email, url: Administrate::Field::Url,
      status: Administrate::Field::Select } => %i[title email url status],
    { views: Administrate::Field::Number } => [],
    { author: searchable(Administrate::Field::BelongsTo), owner: searchable(Administrate::Field::Polymorphic) } =>
      [:author],
    { custom: unrecognized_field } => []
  }.each do |fields, names|
    it "builds the filters #{names.inspect} for #{fields.keys.inspect}" do
      expect(filters_for(fields).keys).to eq(names)
    end
  end

  it 'swaps the matcher of one column for a built-in one, by name' do
    one = Article.create!(title: 'one')
    Article.create!(title: 'one more')

    expect(filters_for(title: filter_option(:exact))[:title].call(Article.all, 'one')).to contain_exactly(one)
  end

  it 'uses a lambda as the filter for one field' do
    only_none = ->(scope, _value) { scope.none }

    expect(filters_for(title: filter_option(only_none))[:title]).to be(only_none)
  end
end
