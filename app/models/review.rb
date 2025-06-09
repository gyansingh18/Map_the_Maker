class Review < ApplicationRecord
  belongs_to :user
  belongs_to :maker
  has_many :review_products
  validates :overall_rating, presence: true
end
