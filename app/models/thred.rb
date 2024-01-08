class Thred < ApplicationRecord
  belongs_to :category
  has_many :followups, dependent: :destroy

  validates :title, presence: true
  validates :username, presence: true
  validates :content, presence: true
  validates :upvotes, presence: true
  
end
