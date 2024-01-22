class Followup < ApplicationRecord
  belongs_to :thred
  belongs_to :user

  validates :content, presence: true
  validates :upvotes, presence: true
end
