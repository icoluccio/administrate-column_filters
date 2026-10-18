require 'spec_helper'

RSpec.describe Administrate::ColumnFilters::Builders::Ranged do
  let(:bare) { Class.new(described_class) }

  %w[5 >5 5..9].each do |typed|
    it "leaves the matching of #{typed.inspect} to subclasses" do
      expect { bare.new(:views).apply(Article.all, typed) }.to raise_error(NotImplementedError)
    end
  end
end
