require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Comparison do
  it_behaves_like 'a column filter builder', column: :views, matching: 3, other: 30, typed: '3'

  {
    '>10' => %i[fifteen], '>=10' => %i[ten fifteen], '<10' => %i[five], '<=10' => %i[five ten],
    '5..10' => %i[five ten], '10..10' => %i[ten], '10' => %i[ten],
    '<5.7' => %i[five], '>5.7' => %i[ten fifteen], '5.7' => [], '>=5.0' => %i[five ten fifteen],
    '4.5..5.5' => %i[five],
    'abc' => [], '>abc' => [], '5..' => [], '..5' => [], '>' => [], '0x1A' => [], 'NaN' => [], 'Infinity' => [],
    '1e999999' => [], '1e-999999' => [], "1#{'0' * 40}" => [], '1e3' => []
  }.each do |typed, names|
    it "answers #{typed.inspect} with #{names.inspect}" do
      rows = view_counts

      expect(filter(:views, typed)).to match_array(names.map { |name| rows[name] })
    end
  end
end
