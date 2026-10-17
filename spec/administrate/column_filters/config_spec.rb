require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Config do
  after { described_class.reset! }

  delegate :builder_for, to: :described_class

  it 'maps the Administrate field types to their builders' do
    expect(config_mappings.keys.map { |field| [field, builder_for(field)] }).to eq(config_mappings.to_a)
  end

  it 'gives no builder to a field type it does not know' do
    expect(builder_for(Class.new(Administrate::Field::Base))).to be_nil
  end

  it 'prefers the builder registered for a field class and its subclasses' do
    money = Class.new(Administrate::Field::String)
    exact = Administrate::ColumnFilters::Builders::Exact
    described_class.register(money, exact)

    expect([builder_for(money), builder_for(Class.new(money))]).to eq([exact, exact])
  end

  it 'forgets a registered builder on reset' do
    custom = Class.new(Administrate::Field::Base)
    described_class.register(custom, Administrate::ColumnFilters::Builders::Exact)
    described_class.reset!

    expect(builder_for(custom)).to be_nil
  end
end
