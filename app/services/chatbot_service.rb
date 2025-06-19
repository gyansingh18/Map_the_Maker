class ChatbotService
  def initialize(question)
    @question = question
    @client = OpenAI::Client.new
  end

  def call
    chatgpt_response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai
      }
    )
    new_content = chatgpt_response["choices"][0]["message"]["content"].gsub("**", "")

    @question.update(ai_answer: new_content)
    Turbo::StreamsChannel.broadcast_update_to(
      "question_#{@question.id}",
      target: "question_#{@question.id}",
      partial: "questions/question", locals: { question: @question })
  end


  def questions_formatted_for_openai
    # questions = @question.user.questions
    # results = []
    # results << { role: "system", content: "You are an assistant for an e-commerce website." }
    # questions.each do |question|
    #   results << { role: "user", content: question.user_question }
    #   results << { role: "assistant", content: question.ai_answer || "" }
    # end
    # return results

    questions = @question.user.questions
    results = []

    system_text = "You are an assistant for a website that helps users discover local producers of grocery items. You should help the user discover producers (called makers) with the closest match to their request. Do not bold any text in the response. Do not directly cite data but paraphrase it. Here are the makers and information on them that you should use to answer the user's questions: "

    nearest_makers.each do |maker|
      system_text += "** maker #{maker.id}: name: #{maker.name}, description: #{maker.description}, location: #{maker.location}, offered product categories: #{maker.categories}, reviews by users: **"
      maker.reviews.each_with_index do |review, index|
        system_text += "** #{maker.id} review #{index + 1}: comment: #{review.comment}, overall rating: #{review.overall_rating}, freshness rating: #{review.freshness_rating}, product range rating: #{review.product_range_rating} **"
      end
    end
    results << { role: "system", content: system_text }

    questions.each do |question|
      results << { role: "user", content: question.user_question }
      results << { role: "assistant", content: question.ai_answer || "" }
    end

    return results
  end

  def nearest_makers
    response = @client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: @question.user_question
      }
    )

    question_embedding = response['data'][0]['embedding']

    return Maker.nearest_neighbors(
      :embedding, question_embedding,
      distance: "euclidean"
    ) # you may want to add .first(3) here to limit the number of results
  end
end
