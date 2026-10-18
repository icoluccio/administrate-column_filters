require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Boolean do
  it_behaves_like 'a column filter builder', column: :published, matching: true, other: false, typed: 'true'

  describe 'a typed value' do
    let!(:on) { Article.create!(published: true) }
    let!(:off) { Article.create!(published: false) }

    %w[true TRUE t 1 yes Y on].each do |typed|
      it "reads #{typed.inspect} as true" do
        expect(filter(:published, typed)).to contain_exactly(on)
      end
    end

    %w[false F 0 no n OFF].each do |typed|
      it "reads #{typed.inspect} as false" do
        expect(filter(:published, typed)).to contain_exactly(off)
      end
    end

    %w[abc maybe 2 truee].each do |typed|
      it "matches nothing for #{typed.inspect}" do
        expect(filter(:published, typed)).to be_empty
      end
    end
  end
end
