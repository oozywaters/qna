class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_question, only: %i[create]

  def create
    @answers = @question.answers
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
    flash[:notice] = 'You answered a question'
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
    else
      flash[:alert] = "Сan not remove someone else's answer"
    end
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
