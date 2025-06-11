class Product < ApplicationRecord
  has_many :review_products
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_create :capitalize_name

  def capitalize_name
    name.capitalize!
  end
end
