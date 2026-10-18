require 'spec_helper'

RSpec.describe 'Administrate search with generated column filters', type: :feature do
  let(:tech) do
    Article.create!(title: 'Tech Weekly', views: 3, published: true, email: 'ana@tech.dev',
                    author: Author.create!(name: 'Ana'), comments: [Comment.new(body: 'Nice')])
  end
  let(:cooking) do
    Article.create!(title: 'Cooking Notes', views: 30, published: false, email: 'bo@food.org', status: 'draft')
  end
  let(:elsewhere) { Article.create!(title: 'Cooking', email: 'tech@food.org', status: 'draft') }

  before { %i[tech cooking elsewhere].each { |name| send(name) } }

  {
    'title:tech' => %i[tech], 'views:3' => %i[tech], 'published:false' => %i[cooking elsewhere],
    'status:draft' => %i[cooking elsewhere], 'views:>10' => %i[cooking], 'released_on:<2026-10-17' => [],
    'title:notes published:false' => %i[cooking], 'drafts:' => %i[cooking elsewhere],
    'email:tech' => %i[tech elsewhere], 'tech' => %i[tech elsewhere]
  }.each do |term, names|
    it "answers #{term} with #{names.inspect}" do
      expect(search(term)).to match_array(names.map { |name| send(name) })
    end
  end

  it 'filters by the id of a belongs-to association' do
    expect(search("author:#{tech.author_id}")).to contain_exactly(tech)
  end

  it 'filters by the id of a has-many association' do
    expect(search("comments:#{tech.comments.first.id}")).to contain_exactly(tech)
  end
end
