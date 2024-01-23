class Category < ApplicationRecord
  has_many :threds, dependent: :destroy
  
  validates :name, presence: true
  validates :description, presence: true
  validates :colour, format: {with: /#[0-9a-fA-F]{6}/, message: "must be a valid hex color code (e.g., #RRGGBB)" }
end
