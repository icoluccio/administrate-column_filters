require 'spec_helper'

RSpec.describe 'GET /admin/articles', type: :request do
  include Rack::Test::Methods

  def app
    Rails.application
  end

  before do
    Article.create!(title: 'Tech Weekly', views: 3, published: true)
    Article.create!(title: 'Cooking Notes', views: 30, published: false)
  end

  it 'lists the row that matches a column filter typed into the search bar' do
    get '/admin/articles', search: 'title:tech'

    expect(last_response.body).to include('Tech Weekly')
  end

  it 'leaves out the row that does not match that column filter' do
    get '/admin/articles', search: 'title:tech'

    expect(last_response.body).not_to include('Cooking Notes')
  end

  it 'lists every row without a search term' do
    get '/admin/articles'

    expect(last_response.body).to include('Tech Weekly', 'Cooking Notes')
  end
end
