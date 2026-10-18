require 'spec_helper'

RSpec.describe Administrate::ColumnFilters do
  describe '.for' do
    it 'returns one filter per searchable column of the dashboard' do
      expect(described_class.for(ArticleDashboard).keys).to eq(
        %i[title views published email url status published_at released_on author comments]
      )
    end
  end

  describe '.configure' do
    after { Administrate::ColumnFilters::Config.reset! }

    it 'yields the configuration, where a builder can be registered for a custom field type' do
      money = Class.new(Administrate::Field::Base) { def self.searchable? = true }
      dashboard = Class.new { const_set(:ATTRIBUTE_TYPES, { price: money }) }
      described_class.configure { |config| config.register(money, Administrate::ColumnFilters::Builders::Exact) }

      expect(described_class.for(dashboard).keys).to eq([:price])
    end
  end

  it 'exposes its version' do
    expect(described_class::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
