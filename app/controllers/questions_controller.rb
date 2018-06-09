class QuestionsController < ApplicationController
  include Ratinged

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show]
  before_action :find_current_user_question, only: [:destroy, :update]
  before_action :build_answer, only: :show

  after_action :publish_question, only: :create

  respond_to :js, :html

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = current_user.questions.build)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  private

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = Question.find(params[:id])
    @answers = @question.answers.by_best
  end

  def find_current_user_question
    @question = current_user.questions.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', question: @question)
  end
end
