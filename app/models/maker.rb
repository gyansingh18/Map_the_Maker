class Maker < ApplicationRecord
  has_many_attached :photos
  belongs_to :user
  has_many :reviews
  validates :categories, presence: true
  validates :name, presence: true

  CATEGORIES = ["meat", "seafood", "vegetables", "fruits", "dairy", "other", "drinks", "grains", "bakery & pastries", "eggs"]

  def average_rating
    if reviews.present?
      reviews.average(:overall_rating).round(2) # Changed to :overall_rating
    else
      "No reviews yet"
    end
  end
end
