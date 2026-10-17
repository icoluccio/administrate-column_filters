require 'spec_helper'

RSpec.describe Administrate::ColumnFilters do
  it 'loads in a process where Rails and Active Record are not already loaded' do
    loaded = system(RbConfig.ruby, '-Ilib', '-e', 'require "administrate/column_filters"')

    expect(loaded).to be(true)
  end
end
