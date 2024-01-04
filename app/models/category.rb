class Category < ApplicationRecord
  has_many :threds
  
  validates :name, presence: true
  validates :description, presence: true
  validates :colour, presence: true
end
