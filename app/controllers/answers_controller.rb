class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :find_question, only: %i[new show create]

  def create
    @answers = @question.answers
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'You answered a question'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
