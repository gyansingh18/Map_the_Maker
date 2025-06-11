class Maker < ApplicationRecord
  belongs_to :user
  has_many :reviews
  validates :categories, presence: true
  validates :name, presence: true

  CATEGORIES = ["meat", "seafood", "vegetables", "fruits", "dairy", "other", "drinks", "grains", "bakery & pastries", "eggs" ]
end
