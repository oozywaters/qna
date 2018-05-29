class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy select_best]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy select_best]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
    flash[:notice] = 'You answered a question'
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      flash[:alert] = "Сan not edit someone else's answer"
    end
  end

  def select_best
    if current_user.author_of?(@answer.question)
      @answer.select_best
    else
      flash[:alert] = 'You are not the author of this question'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
    else
      flash[:alert] = "Сan not remove someone else's answer"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
