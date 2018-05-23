class AnswersController < ApplicationController
  before_action :find_question, only: %i[new show create]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)

    if @answer.save
      redirect_to @answer.question
    else
      render :new
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
