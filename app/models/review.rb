class Review < ApplicationRecord
  belongs_to :user
  belongs_to :maker
  has_many :review_products
  has_many :products, through: :review_products
  validates :overall_rating, presence: true
  validates :service_rating, presence: true
  validates :product_range_rating, presence: true

  after_create :award_maker_added_karma

  private

  def award_maker_added_karma
    user.add_karma_points(:review_submitted, source: self)
  end
end
