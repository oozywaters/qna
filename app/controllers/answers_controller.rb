class AnswersController < ApplicationController
  include Ratinged

  before_action :authenticate_user!, only: %i[create destroy select_best]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy select_best]

  after_action :publish_answer, only: :create

  authorize_resource

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
      @question = @answer.question
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
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?
    attachments = @answer.attachments.map do |a|
      { id: a.id, url: a.file.url, name: a.file.identifier }
    end
    ActionCable.server.broadcast(
        "answers_for_question_#{@answer.question_id}",
        answer: @answer, attachments: attachments,
        question_user_id: @answer.question.user_id
    )
  end
end
