class AnswersController < ApplicationController
  include Ratinged

  before_action :authenticate_user!, only: %i[create destroy select_best]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[select_best]
  before_action :find_current_user_answer, only: %i[destroy update]

  after_action :publish_answer, only: :create

  authorize_resource

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def select_best
    @answer.select_best unless @answer.best?
  end

  def destroy
    @answer.destroy
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

  def find_current_user_answer
    @answer = current_user.answers.find(params[:id])
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
