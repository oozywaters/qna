class QuestionsController < ApplicationController
  include Ratinged

  before_action :authenticate_user!, except: %i[index show update]
  before_action :find_question, only: %i[show destroy update]

  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.by_best
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.build
    @question.attachments.build
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question was successfully deleted'
    else
      flash[:alert] = "Сan not remove someone else's question"
    end
    redirect_to questions_path
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      flash[:notice] = 'Question was succesfully edited'
    else
      flash[:alert] = "You can not delete someone else's question"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions', question: @question)
  end
end
