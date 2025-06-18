class QuestionsController < ApplicationController
  def index
    @questions = current_user.questions
    @question = Question.new
  end

   def create
    @questions = current_user.questions
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:questions, partial: "questions/question",
            locals: { question: @question })
        end
        format.html { redirect_to questions_path }
      end
    else
     render :index, status: :unprocessable_entity
    end
  end

  def reset
    current_user.questions.destroy_all
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:user_question)
  end

end
