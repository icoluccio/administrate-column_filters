ActiveRecord::Schema[7.1].define(version: 2026_01_01_000000) do
  create_table 'authors', force: :cascade do |t|
    t.string 'name'
  end

  create_table 'articles', force: :cascade do |t|
    t.string 'title'
    t.text 'summary'
    t.integer 'views', default: 0
    t.boolean 'published', default: false
    t.string 'group'
    t.string 'email'
    t.string 'url'
    t.integer 'status'
    t.datetime 'published_at'
    t.date 'released_on'
    t.integer 'author_id'
    t.index ['author_id'], name: 'index_articles_on_author_id'
  end

  create_table 'comments', force: :cascade do |t|
    t.integer 'article_id'
    t.text 'body'
    t.index ['article_id'], name: 'index_comments_on_article_id'
  end
end
