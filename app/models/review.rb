class Review < ApplicationRecord
  belongs_to :user
  belongs_to :maker
  has_many :review_products
  has_many :products, through: :review_products
  validates :overall_rating, presence: true
  validates :service_rating, presence: true
  validates :product_range_rating, presence: true
  validates :accuracy_rating, presence: true
end
