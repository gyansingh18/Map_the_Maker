class Maker < ApplicationRecord
  has_many_attached :photos
  belongs_to :user
  has_many :reviews
  validates :categories, presence: true
  validates :name, presence: true
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  CATEGORIES = ["meat", "seafood", "vegetables", "fruits", "dairy", "other", "drinks", "grains", "bakery & pastries", "eggs" ]
end
