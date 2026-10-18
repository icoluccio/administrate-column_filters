require 'spec_helper'

RSpec.describe Administrate::ColumnFilters do
  describe 'the packaged gem' do
    let(:files) do
      Gem::Specification.load(File.expand_path('../../administrate-column_filters.gemspec', __dir__)).files
    end

    it 'includes the library, the README, the license and the changelog' do
      expect(files).to include('lib/administrate/column_filters.rb', 'README.md', 'LICENSE.md', 'CHANGELOG.md')
    end

    it 'leaves tooling and specs out' do
      expect(files.grep_v(%r{\Alib/})).to match_array(%w[README.md LICENSE.md CHANGELOG.md])
    end
  end
end
