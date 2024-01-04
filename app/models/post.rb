class Post < ApplicationRecord
  belongs_to :thred

  validates :username, presence: true
  validates :content, presence: true
  validates :upvotes, presence: true
end
