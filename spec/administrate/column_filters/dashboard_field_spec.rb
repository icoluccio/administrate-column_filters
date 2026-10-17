require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::DashboardField do
  let(:deferred) { Administrate::Field::String.with_options(searchable: true, filter: :exact) }
  let(:field) { described_class.new(:title, deferred) }
  let(:bare) { described_class.new(:views, Administrate::Field::Number) }

  it 'keeps the attribute name it was built with' do
    expect(field.name).to eq(:title)
  end

  it 'asks the deferred field whether it is searchable' do
    expect(field.searchable?).to be(true)
  end

  it 'reads the filter option of a deferred field' do
    expect(field.filter_override).to eq(:exact)
  end

  it 'reads the field class behind a deferred field' do
    expect(field.field_class).to eq(Administrate::Field::String)
  end

  it 'asks a bare field class whether it is searchable' do
    expect(bare.searchable?).to be(false)
  end

  it 'reports no filter option for a bare field class' do
    expect(bare.filter_override).to be_nil
  end

  it 'reads a field declared as a bare class' do
    expect(bare.field_class).to eq(Administrate::Field::Number)
  end
end
