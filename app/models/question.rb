class Question < ApplicationRecord
  belongs_to :user
  validates :user_question, presence: true

  after_create :set_question

  def set_question
    ChatbotService.new(self).call
  end
end
