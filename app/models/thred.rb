class Thred < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :followups, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
  validates :upvotes, presence: true
  
end
