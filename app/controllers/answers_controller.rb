class AnswersController < ApplicationController
  before_action :find_question, only: %i[new show]

  def new
    @answer = @question.answers.build
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
