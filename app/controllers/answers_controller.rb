class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
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
