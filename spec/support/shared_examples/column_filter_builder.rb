RSpec.shared_examples 'a column filter builder' do |column:, matching:, other:, typed:|
  let(:filter) { described_class.new(column).to_proc }

  it 'keeps the records that match the typed value' do
    match = Article.create!(column => matching)
    Article.create!(column => other)

    expect(filter.call(Article.all, typed)).to contain_exactly(match)
  end

  it 'leaves the scope alone when the typed value is blank' do
    Article.create!(column => matching)
    Article.create!(column => other)

    expect([nil, ''].map { |blank| filter.call(Article.all, blank).count }).to eq([2, 2])
  end

  it 'takes the scope and the typed value, the arguments Administrate passes' do
    expect(filter.parameters.size).to eq(2)
  end
end
