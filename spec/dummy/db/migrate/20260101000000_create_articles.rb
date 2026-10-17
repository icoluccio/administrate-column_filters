class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :name
    end

    create_table :articles do |t|
      t.string :title
      t.text :summary
      t.integer :views, default: 0
      t.boolean :published, default: false
      t.string :group
      t.string :email
      t.string :url
      t.integer :status
      t.datetime :published_at
      t.date :released_on
      t.references :author
    end

    create_table :comments do |t|
      t.references :article
      t.text :body
    end
  end
end
