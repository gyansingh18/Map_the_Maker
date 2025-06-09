class Product < ApplicationRecord
  has_many :review_products
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
