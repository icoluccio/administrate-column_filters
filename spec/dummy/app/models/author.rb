class Author < ApplicationRecord
  has_many :articles, dependent: :nullify
end
