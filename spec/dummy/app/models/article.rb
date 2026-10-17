class Article < ApplicationRecord
  enum :status, { draft: 0, published: 1 }

  belongs_to :author, optional: true
  has_many :comments, dependent: :destroy
end
