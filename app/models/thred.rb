class Thred < ApplicationRecord
  belongs_to :category
  has_many :posts, dependent: :destroy

  validates :title, presence: true
end
