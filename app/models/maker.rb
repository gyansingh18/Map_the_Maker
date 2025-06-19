class Maker < ApplicationRecord
  acts_as_favoritable
  has_many_attached :photos
  belongs_to :user
  has_many :reviews
  validates :categories, presence: true
  validates :name, presence: true
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  has_neighbors :embedding
  after_create :set_embedding

  CATEGORIES = ["meat", "seafood", "vegetables", "fruits", "dairy", "other", "drinks", "grains", "bakery & pastries", "eggs"]

  def average_rating
    if reviews.present?
      reviews.average(:overall_rating).round(2)
    else
      "NA"
    end
  end

    has_many :reviews, dependent: :destroy

  def average_star_rating_freshness
     if reviews.present?
      reviews.average(:freshness_rating).round(2)
    else
      "NA"
    end
  end

  def average_star_rating_service
 if reviews.present?
      reviews.average(:service_rating).round(2)
    else
      "NA"
    end
  end

  def average_star_rating_product_range
 if reviews.present?
      reviews.average(:product_range_rating).round(2)
    else
      "NA"
    end
  end


    def average_star_rating_accuracy
 if reviews.present?
      reviews.average(:accuracy_rating).round(2)
    else
      "NA"
    end
  end






  private

  def set_embedding
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: "Maker: #{name}. Description: #{description} location: #{location}"
      }
    )
    embedding = response['data'][0]['embedding']
    update(embedding: embedding)

  end
end
