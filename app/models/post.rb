class Post < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :tags

  validates :username, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :upvotes, presence: true

end
