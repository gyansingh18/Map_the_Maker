class ReviewProduct < ApplicationRecord
  belongs_to :product
  belongs_to :review
end
